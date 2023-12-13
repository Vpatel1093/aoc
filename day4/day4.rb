def day_4_part_1(file_name)
    winning_number_sets, card_number_sets = get_number_sets(file_name)
    total_card_points = 0

    winning_number_sets.each_with_index do |winning_number_set, i|
        winning_number_count = (winning_number_set & card_number_sets[i]).length

        card_points = winning_number_count == 0 ? 0 : 2**(winning_number_count - 1)
        total_card_points += card_points
    end
    
    puts total_card_points
end

def day_4_part_2(file_name)
    winning_number_sets, card_number_sets = get_number_sets(file_name)
    card_counts = Array.new(card_number_sets.length, 1)

    winning_number_sets.each_with_index do |winning_number_set, i|
        winning_number_count = (winning_number_set & card_number_sets[i]).length

        if winning_number_count > 0
            winning_number_count.times do |count|
                unless card_counts[i + 1 + count].nil?
                    card_counts[i + 1 + count] += card_counts[i]
                end
            end
        end
    end

    puts card_counts.sum
end

def get_number_sets(file_name)
    winning_number_sets = []
    card_number_sets = []

    File.open(file_name, 'r') do |file|
        # Read each line from the file and add it to the array
        file.each_line do |line|
            line_without_header = line.chomp.split(": ")[1]
            number_sets = line_without_header.split(' | ')

            winning_number_set = number_sets[0].split(' ')
            winning_number_sets << winning_number_set

            card_number_set = number_sets[1].split(' ')
            card_number_sets << card_number_set
        end
    end

    return winning_number_sets, card_number_sets
end

day_4_part_1("example.txt")
day_4_part_1("input.txt")
day_4_part_2("example.txt")
day_4_part_2("input.txt")