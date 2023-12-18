def day_11(file_name, galaxy_age_factor)
    grid = get_grid(file_name)
    rows_to_expand, columns_to_expand = get_expansion_indices(grid)
    galaxy_coords = get_galaxy_coords(grid)
    galaxy_path_combinations = galaxy_coords.combination(2)
    sum_of_shortest_paths = 0

    galaxy_path_combinations.each do |galaxy_a, galaxy_b|
        sum_of_shortest_paths += (galaxy_b[0] - galaxy_a[0]).abs + (([galaxy_a[0], galaxy_b[0]].min..[galaxy_a[0], galaxy_b[0]].max).to_a & rows_to_expand).count * (galaxy_age_factor - 1)
        sum_of_shortest_paths += (galaxy_b[1] - galaxy_a[1]).abs + (([galaxy_a[1], galaxy_b[1]].min..[galaxy_a[1], galaxy_b[1]].max).to_a & columns_to_expand).count * (galaxy_age_factor - 1)
    end

    puts sum_of_shortest_paths
end

def get_grid(file_name)
    grid = []

    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            grid << line.chomp.split('')
        end
    end

    return grid
end

def get_expansion_indices(grid)
    rows_to_expand = []
    grid.each_with_index do |row, row_index|
        if row.all? {|element| element == '.'}
            rows_to_expand << row_index
        end
    end

    columns_to_expand = []
    (0..grid[0].length - 1).to_a.each do |column_index|
        column = grid.map { |row| row[column_index] }

        if column.all? {|element| element == '.'}
            columns_to_expand << column_index
        end
    end

    return rows_to_expand, columns_to_expand
end

def get_galaxy_coords(grid)
    coords = []

    grid.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
            coords << [row_index, col_index] if col == '#'
        end
    end

    return coords
end

day_11("example.txt", 2)
day_11("input.txt", 2)
day_11("example.txt", 10)
day_11("example.txt", 100)
day_11("input.txt", 1000000)