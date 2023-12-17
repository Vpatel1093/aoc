CARDINAL_DIRECTIONS = {
    "north" => [ 0, -1, "north" ],
    "east" => [ 1, 0, "east" ],
    "south" => [ 0, 1, "south" ],
    "west" => [ -1, 0, "west" ]
}
PIPE_DIRECTION_MAPPING = {
    '|' => { "north" => CARDINAL_DIRECTIONS["north"], "south" => CARDINAL_DIRECTIONS["south"] },
    '-' => { "east" => CARDINAL_DIRECTIONS["east"], "west" => CARDINAL_DIRECTIONS["west"] },
    'L' => { "south" => CARDINAL_DIRECTIONS["east"], "west" => CARDINAL_DIRECTIONS["north"] },
    'J' => { "south" => CARDINAL_DIRECTIONS["west"], "east" => CARDINAL_DIRECTIONS["north"] },
    '7' => { "east" => CARDINAL_DIRECTIONS["south"], "north" => CARDINAL_DIRECTIONS["west"] },
    'F' => { "north" => CARDINAL_DIRECTIONS["east"], "west" => CARDINAL_DIRECTIONS["south"] },
    '.' => {},
    'S' => {}
}

def day_10(file_name)
    grid, start_location = get_grid_and_start_location(file_name)
    loop_length = 0
    
    CARDINAL_DIRECTIONS.values.each do |next_direction|
        current_x = start_location[0]
        current_y = start_location[1]
        current_pipe = ''
        loop_length = 0
        current_direction = next_direction[2]
        
        until current_pipe == 'S'
            loop_length += 1
            current_x = current_x + next_direction[0]
            current_y = current_y + next_direction[1]
            current_pipe = grid[current_x][current_y]
            
            next_direction = PIPE_DIRECTION_MAPPING[current_pipe][current_direction]
            break if next_direction.nil?
            current_direction = next_direction[2]
        end

        break if current_pipe == 'S'
    end

    puts loop_length / 2
end

def get_grid_and_start_location(file_name)
    grid = []
    start_location = []

    File.open(file_name, 'r') do |file|
        file.each_line.with_index do |line, index|
            row = line.chomp.split('')
            grid << row
        end
    end
    grid = grid.transpose
    grid.each_with_index do |column, index|
        start_location = [index, column.index('S')] if column.any? {|el| el == 'S'}
    end

    return grid, start_location
end

day_10("example1.txt")
day_10("example2.txt")
day_10("input.txt")