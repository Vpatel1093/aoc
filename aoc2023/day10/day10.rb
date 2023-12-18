CARDINAL_DIRECTIONS = {
    "north" => [ -1, 0, "north" ],
    "east" => [ 0, 1, "east" ],
    "south" => [ 1, 0, "south" ],
    "west" => [ 0, -1, "west" ]
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
    vertical_edge_grid = Array.new(grid.length) { Array.new(grid[0].length) }
    visited_grid = Array.new(grid.length) { Array.new(grid[0].length) }
    
    CARDINAL_DIRECTIONS.values.each do |next_direction|
        # reset in case prior loop attempt failed
        vertical_edge_grid = Array.new(grid.length) { Array.new(grid[0].length) }
        visited_grid = Array.new(grid.length) { Array.new(grid[0].length) }
        
        current_y = start_location[0]
        current_x = start_location[1]
        current_pipe = ''
        loop_length = 0
        current_direction = next_direction[2]
        
        until current_pipe == 'S'
            loop_length += 1
            current_y = current_y + next_direction[0]
            current_x = current_x + next_direction[1]
            current_pipe = grid[current_y][current_x]
            visited_grid[current_y][current_x] = '~' # track visited elements
            
            next_direction = PIPE_DIRECTION_MAPPING[current_pipe][current_direction]
            break if next_direction.nil?
            current_direction = next_direction[2]

            # Defining a vertical edge as any element that connects to the element above it
            if ["|", "J", "L"].include?(current_pipe) && ["|", "7", "F", "S"].include?(grid[current_y - 1][current_x])
                vertical_edge_grid[current_y][current_x] = "|"
            end
        end

        break if current_pipe == 'S'
    end

    inside_outside_grid = get_inside_outside_grid(visited_grid, vertical_edge_grid)

    inside_count = inside_outside_grid.flatten.count("I")

    puts loop_length / 2, inside_count
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
    grid.each_with_index do |row, index|
        start_location = [index, row.index('S')] if row.any? {|el| el == 'S'}
    end

    return grid, start_location
end

# Point-in-polygon problem - use even-odd algo to determine if points are inside/outside
# of the polygon that is formed by the visited path
# Even crossings -> outside, odd crossings -> inside
# Note: Horizontal edges of polygon are not crossings
def get_inside_outside_grid(visited_grid, vertical_edge_grid)
    inside_outside_grid = Array.new(visited_grid.length) { Array.new(visited_grid[0].length) }

    visited_grid.each_with_index do |row, row_index|
        crossings = 0

        row.each_with_index do |element, column_index|
            crossings += 1 if vertical_edge_grid[row_index][column_index] == "|"

            if visited_grid[row_index][column_index].nil?
                if crossings % 2 == 1 && crossings > 0
                    inside_outside_grid[row_index][column_index] = "I"
                end
            end
        end
    end

    return inside_outside_grid
end

day_10("example1.txt")
day_10("example2.txt")
day_10("example3.txt")
day_10("example4.txt")
day_10("input.txt")