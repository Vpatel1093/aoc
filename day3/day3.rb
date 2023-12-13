DIRECTIONS = [ [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0] ]

def day_3_part_1(file_name)
    inputs = set_up_inputs_array(file_name)
    sum = 0
    engines = []
    x_length = inputs[0].length
    y_length = inputs.length

    symbol_coords = get_symbol_coords(inputs)

    symbol_coords.each do |coordinates|
        y, x = coordinates

        DIRECTIONS.each do |direction|
            y_change, x_change = direction

            new_x = x + x_change
            new_y = y + y_change

            if new_x >= 0 && new_x < x_length && new_y >= 0 && new_y < y_length && inputs[new_y][new_x].match?(/\d/)
                sum += discover_integer(new_y, new_x, inputs, true)
            end
        end
    end
    
    puts sum
end

def day_3_part_2(file_name)
    inputs = set_up_inputs_array(file_name)
    x_length = inputs[0].length
    y_length = inputs.length
    gear_ratios = 0

    gear_coords = get_gear_coords(inputs)

    gear_coords.each do |coordinates|
        y, x = coordinates
        gear_ratio_group = Set.new

        DIRECTIONS.each do |direction|
            y_change, x_change = direction

            new_x = x + x_change
            new_y = y + y_change

            if new_x >= 0 && new_x < x_length && new_y >= 0 && new_y < y_length && inputs[new_y][new_x].match?(/\d/)
                gear_ratio_group.add(discover_integer(new_y, new_x, inputs))
            end
        end
        
        
        if gear_ratio_group.length > 1
            gear_ratios += gear_ratio_group.inject(1) { |product, element| product * element }
        end
    end

    puts gear_ratios
end

def set_up_inputs_array(file_name)
    inputs = []

    File.open(file_name, 'r') do |file|
        # Read each line from the file and add it to the array
        file.each_line do |line|
            inputs << line.chomp.split('')
        end
    end

    return inputs
end

def get_symbol_coords(inputs)
    symbol_coords = Set.new

    inputs.each_with_index do |line, y|
        line.each_with_index do |char, x|
            unless char.match?(/\d|\./)
                symbol_coords.add([y, x])
            end
        end
    end

    return symbol_coords
end

def get_gear_coords(inputs)
    gear_coords = Set.new

    inputs.each_with_index do |line, y|
        line.each_with_index do |char, x|
            if char.match?(/\*/)
                gear_coords.add([y, x])
            end
        end
    end

    return gear_coords
end

def discover_integer(y, x, inputs, mask_after_discovery = false)
    start_x = x
    end_x = x

    start_x -= 1 while start_x - 1 >= 0 && inputs[y][start_x - 1].match?(/\d/)
    end_x += 1 while end_x + 1 < inputs[0].length && inputs[y][end_x + 1].match?(/\d/)

    integer = inputs[y][start_x..end_x].join('').to_i
    (start_x..end_x).each { |x| inputs[y][x] = '~' } if mask_after_discovery

    return integer
end

day_3_part_1("example.txt")
day_3_part_1("input.txt")
day_3_part_2("example.txt")
day_3_part_2("input.txt")