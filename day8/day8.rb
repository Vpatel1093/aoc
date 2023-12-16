def day_8_part_1(file_name)
    lr, mapping = get_lr_and_mapping(file_name)
    curr = "AAA"
    steps = 0
    orig_lr = lr.dup

    until curr == "ZZZ"
        curr = mapping[curr][lr.slice!(0)]

        lr = orig_lr.dup if lr.empty?
        steps += 1
    end

    puts steps
end

def day_8_part_2(file_name)
    lr, mapping = get_lr_and_mapping(file_name)
    current_nodes = mapping.keys.select { |key| key[2] == 'A' }
    steps = 0
    steps_until_end_z_per_node = Array.new(current_nodes.length, nil)
    orig_lr = lr.dup

    until steps_until_end_z_per_node.all? { |node| !node.nil? }
        current_direction = lr.slice!(0)
        current_nodes.each_with_index do |node, index|
            steps_until_end_z_per_node[index] = steps if node.match?(/.*Z\z/)
        end
        current_nodes = current_nodes.map {|node| node = mapping[node][current_direction] }

        lr = orig_lr.dup if lr.empty?
        steps += 1
    end

    steps_until_end_z_for_all_nodes = steps_until_end_z_per_node.reduce { |lcm, steps| lcm.lcm(steps) }

    puts steps_until_end_z_for_all_nodes
end

def get_lr_and_mapping(file_name)
    lr = ""
    mapping = {}

    File.open(file_name, 'r') do |file|
        lr = file.readline.chomp
        file.readline
        
        file.each_line do |line|
            key = line[0..2]

            mapping[key] = { 'L' => line[7..9], 'R' => line[12..14] }
        end
    end

    return lr, mapping
end

day_8_part_1("example1.txt")
day_8_part_1("example2.txt")
day_8_part_1("input.txt")
day_8_part_2("example3.txt")
day_8_part_2("input.txt")