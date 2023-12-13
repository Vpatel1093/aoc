def day_5_part_1(file_name)
    mappings = get_mappings(file_name)

    lowest_location = 999999999999999999999
    mappings["seeds"].each do |seed|
        current_location = find_location_within_mappings(seed, mappings.except(mappings.keys.first))
        lowest_location = [lowest_location, current_location].min
    end
    
    puts lowest_location
end

# def day_5_part_2(file_name)
# end

def get_mappings(file_name)
    mappings = {}

    File.open(file_name, 'r') do |file|
        current_mapping = "seeds"
        mappings[current_mapping] = file.readline.chomp.split("seeds: ")[1].split(' ').map(&:to_i)

        # Read each line from the file and add it to the array
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

def find_location_within_mappings(current_unit, mappings)
    return current_unit if mappings.empty?

    new_unit = current_unit
    mappings.first[1].each do |mapping|
        next unless current_unit >= mapping[1] && current_unit <= mapping[1] + mapping[2] - 1
        
        new_unit = mapping[0] + current_unit - mapping[1]
        break
    end

    return find_location_within_mappings(new_unit, mappings.except(mappings.keys.first))
end

day_5_part_1("example.txt")
day_5_part_1("input.txt")
# day_5_part_2("example.txt")
# day_5_part_2("input.txt")