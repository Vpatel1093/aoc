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

def part_1
    sum = 0
    good_games = Set.new
    
    INPUTS.each_with_index do |game, index|
        game = game.split(": ")[1]
        subgames = game.split(";")
        impossible_to_play = false

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
        end
        
        next if impossible_to_play == true

        good_games.add(index + 1)
    end

    return good_games.sum
end

puts part_1