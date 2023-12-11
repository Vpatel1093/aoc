CUBES = {
    "red" => 12,
    "green" => 13,
    "blue" => 14
}
INPUTS = []
File.open('input.txt', 'r') do |file|
    # Read each line from the file and add it to the array
    file.each_line do |line|
        INPUTS << line.chomp
    end
end

def day_2
    good_games = Set.new
    power = 0
    
    INPUTS.each_with_index do |game, index|
        game = game.split(": ")[1]
        subgames = game.split(";")
        impossible_to_play = false
        min_game_cube_counts = {
            "red" => 0,
            "green" => 0,
            "blue" => 0
        }

        subgames.each do |subgame|
            game_cubes_as_strings = subgame.split(", ")
            
            game_cube_counts = {
                "red" => 0,
                "green" => 0,
                "blue" => 0
            }
            game_cubes_as_strings.each do |cube_string|
                if cube_string.include?(" red")
                    game_cube_counts["red"] = cube_string.gsub(" red", "").to_i
                elsif cube_string.include?(" green")
                    game_cube_counts["green"] = cube_string.gsub(" green", "").to_i
                elsif cube_string.include?(" blue")
                    game_cube_counts["blue"] = cube_string.gsub(" blue", "").to_i
                end
            end

            if game_cube_counts.any? { |color, count| count > CUBES[color] }
                impossible_to_play = true
            end

            game_cube_counts.each do |color, count|
                if count > min_game_cube_counts[color]
                    min_game_cube_counts[color] = count
                end
            end
        end

        power += min_game_cube_counts.values.reduce(:*)
        
        next if impossible_to_play == true
        good_games.add(index + 1)
    end

    puts good_games.sum
    puts power
end

day_2