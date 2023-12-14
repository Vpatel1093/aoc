def day_6_part_1(file_name)
    race_data = get_race_data(file_name)

    combinations = 1

    race_data[0].length.times do |race_number|
        race_time = race_data[0][race_number]
        distance_to_beat = race_data[1][race_number]

        seconds_spent_charging = 0
        distance_achievable = 0
        until distance_achievable > distance_to_beat
            distance_achievable = (race_time - seconds_spent_charging) * seconds_spent_charging
            
            seconds_spent_charging += 1
        end

        ways_to_win = (race_time + 1) - ((seconds_spent_charging - 1) * 2)
        combinations *= ways_to_win
    end

    puts combinations
end

# def day_6_part_2(file_name)
    
# end

def get_race_data(file_name)
    race_data = []

    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            race_data << line.split(": ")[1].chomp.split(' ').map(&:chomp).map(&:to_i)
        end
    end

    return race_data
end

day_6_part_1("example.txt")
day_6_part_1("input.txt")
# day_6_part_2("example.txt")
# day_6_part_2("input.txt")