def day_5_part_1(file_name)
    mappings = get_mappings(file_name)

    lowest_location = 999999999999999999999
    mappings["seeds"].each do |seed|
        current_location = get_location_from_mappings(seed, mappings.except(mappings.keys.first))
        lowest_location = [lowest_location, current_location].min
    end
    
    puts lowest_location
end

def day_5_part_2(file_name)
    mappings = get_mappings(file_name)

    lowest_location = 999999999999999999999
    seed_ranges = []
    (mappings["seeds"].length / 2).times do |range_iteration|
        seed_start = mappings["seeds"][range_iteration * 2]
        seed_range_length = mappings["seeds"][range_iteration * 2 + 1]
        seed_end = seed_start + seed_range_length

        seed_ranges << (seed_start..seed_end)
    end
    location_ranges = get_location_ranges_from_mappings(seed_ranges, mappings.except(mappings.keys.first))

    puts location_ranges.min_by(&:begin).begin
end

def get_mappings(file_name)
    mappings = {}

    File.open(file_name, 'r') do |file|
        current_mapping = "seeds"
        mappings[current_mapping] = file.readline.chomp.split("seeds: ")[1].split(' ').map(&:to_i)

        file.each_line do |line|
            if line.start_with?(/[a-z]/)
                current_mapping = line.chomp.split( )[0]
                mappings[current_mapping] = []
            elsif line.start_with?(/[0-9]/)
                mappings[current_mapping] << line.chomp.split(' ').map(&:to_i)
            end
        end
    end

    return mappings
end

def get_location_from_mappings(current_unit, mappings)
    return current_unit if mappings.empty?

    new_unit = current_unit
    mappings.first[1].each do |mapping|
        next unless current_unit >= mapping[1] && current_unit <= mapping[1] + mapping[2] - 1
        
        new_unit = mapping[0] + current_unit - mapping[1]
        break
    end

    return get_location_from_mappings(new_unit, mappings.except(mappings.keys.first))
end

# see sankey diagram for visual of range splitting concept
# idea here is to keep breaking down the ranges into the next group of mapped ranges using a queue
# and recursing until we reach the end of the mapping where the location ranges will be found
def get_location_ranges_from_mappings(current_ranges, mappings)
    return current_ranges if mappings.empty?

    new_ranges = []
    until current_ranges.empty?
        current_range = current_ranges.first
        current_range_leftover = nil
        new_range_created = false

        mappings.first[1].each do |mapping|
            mapping_range = (mapping[1]..mapping[1] + mapping[2] - 1)

            # current range is entirely outside mapping range <--mr-->......<-cr-> so no overlap
            next unless (mapping_range).include?(current_range.first) || (mapping_range).include?(current_range.last)
            
            intersection_range = find_intersection_range_and_handle_leftovers(current_range, mapping_range, current_ranges)

            new_range_start = mapping[0] + intersection_range.first - mapping[1]
            new_range_end = mapping[0] + intersection_range.end - mapping[1]
            new_range = (new_range_start..new_range_end)
            new_ranges << new_range
            new_range_created = true
            break
        end
        
        new_ranges << current_range unless new_range_created
        current_ranges.shift
    end

    return get_location_ranges_from_mappings(new_ranges, mappings.except(mappings.keys.first))
end

def find_intersection_range_and_handle_leftovers(current_range, mapping_range, current_ranges)
    intersection_range = nil

    if mapping_range.first <= current_range.first && current_range.last <= mapping_range.last
        # current range is entirely within or sharing mapping range <<--mr/cr-->> which leaves no leftovers
        # also coveres one shared edge <<-cr->--mr--> or <--mr--<-cr->>
        intersection_range = current_range
    elsif current_range.first < mapping_range.first && mapping_range.last < current_range.last
        # current range is encompassing mapping range <--cr--<-mr->--cr--> which leaves two leftover ranges
        intersection_range = (mapping_range.first..mapping_range.last)
        
        current_range_first_leftover = (current_range.first..mapping_range.first - 1)
        current_range_second_leftover = (mapping_range.last + 1..current_range.last)
        current_ranges << current_range_first_leftover
        current_ranges << current_range_second_leftover
    elsif current_range.first < mapping_range.first && current_range.last <= mapping_range.last
        # current range partially covered by mapping range <-cr-<-mr/cr->(-mr-)> so one leftover range
        # mapping range can share end with cr as well <-cr-<-mr/cr->>
        intersection_range_start = mapping_range.first
        intersection_range_end = current_range.last
        intersection_range = (intersection_range_start..intersection_range_end)
        
        current_range_leftover = (current_range.first..mapping_range.first - 1)
        current_ranges << current_range_leftover
    elsif current_range.first >= mapping_range.first && mapping_range.last < current_range.last
        # current range partially covered by mapping range <(-mr-)<-mr/cr->-cr-> so one leftover range
        # mapping range can share end with cr as well <<-mr/cr->-cr->
        intersection_range_start = current_range.first
        intersection_range_end = mapping_range.last
        intersection_range = (intersection_range_start..intersection_range_end)
        
        current_range_leftover = (mapping_range.last + 1..current_range.last)
        current_ranges << current_range_leftover
    elsif current_range.last == mapping_range.first
        # probably super rare but maybe only last point will intersect <--cr--<.>--mr-->
        intersection_range = (current_range.last..current_range.last)
        
        current_range_leftover = (current_range.first..current_range.last - 1)
        current_ranges << current_range_leftover
    elsif mapping_range.last == current_range.first
        # probably super rare but maybe only first point will intersect <--mr--<.>--cr-->
        intersection_range = (current_range.first..current_range.first)
        
        current_range_leftover = (current_range.first + 1..current_range.last)
        current_ranges << current_range_leftover
    end

    return intersection_range
end

day_5_part_1("example.txt")
day_5_part_1("input.txt")
day_5_part_2("example.txt")
day_5_part_2("input.txt")