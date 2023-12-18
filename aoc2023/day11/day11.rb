def day_11(file_name)
    grid = get_grid(file_name)
    expanded_grid = expand_grid(grid)
    galaxy_coords = get_galaxy_coords(expanded_grid)
    galaxy_path_combinations = galaxy_coords.combination(2)
    sum_of_shortest_paths = 0

    galaxy_path_combinations.each do |galaxy_a, galaxy_b|
        sum_of_shortest_paths += abs(galaxy_b[0] - galaxy_a[0])
        sum_of_shortest_paths += abs(galaxy_b[1] - galaxy_a[1])
    end

    puts sum_of_shortest_paths
end

def get_grid(file_name)
    grid = []


    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            grid << line.split('')
        end
    end

    return grid
end

day_11("example.txt")
day_11("input.txt")