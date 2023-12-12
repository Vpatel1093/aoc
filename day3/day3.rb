INPUTS = []
File.open('input.txt', 'r') do |file|
    # Read each line from the file and add it to the array
    file.each_line do |line|
        INPUTS << line.chomp.split('')
    end
end
SYMBOLS = ['.', '*', '#', '$', '+', ]
DIRECTIONS = [[-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0]]

def day_3_part_1
    sum = 0
    engines = []
    x_length = INPUTS[0].length
    y_length = INPUTS.length

    symbol_coords = get_symbol_coords

    symbol_coords.each do |coordinates|
        y, x = coordinates

        DIRECTIONS.each do |direction|
            y_change, x_change = direction

            new_x = x + x_change
            new_y = y + y_change

            if new_x >= 0 && new_x < x_length && new_y >= 0 && new_y < y_length && INPUTS[new_y][new_x].match?(/\d/)
                engine = discover_integer(new_y, new_x)
                engines << engine
                sum += engine
            end
        end
    end
    
    puts engines
    puts sum
end

def get_symbol_coords
    symbol_coords = Set.new

    INPUTS.each_with_index do |line, y|
        line.each_with_index do |char, x|
            unless char.match?(/\d|\./)
                symbol_coords.add([y, x])
            end
        end
    end

    return symbol_coords
end

def discover_integer(y, x)
    start_x = x
    end_x = x

    start_x -= 1 while start_x - 1 >= 0 && INPUTS[y][start_x - 1].match?(/\d/)
    end_x += 1 while end_x + 1 < INPUTS[0].length && INPUTS[y][end_x + 1].match?(/\d/)

    integer = INPUTS[y][start_x..end_x].join('').to_i
    (start_x..end_x).each { |x| INPUTS[y][x] = '~' }

    return integer
end

day_3_part_1