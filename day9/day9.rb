def day_8_part_1(file_name)
    sequences = get_sequences(file_name)
    sum_of_sequence_ends = 0

    sequences.each do |sequence|
        sequence_pyramid = [sequence]

        until sequence_pyramid.last.all? { |element| element == 0 }
            new_row = Array.new(sequence_pyramid.last.length - 1, nil)
            new_row = new_row.map.with_index { |element, index| element = sequence_pyramid.last[index + 1] - sequence_pyramid.last[index] }
            sequence_pyramid << new_row
        end
    
        pyramid_height = sequence_pyramid.length
        (pyramid_height - 1).times do |index|
            sequence_pyramid[pyramid_height - index - 2] <<  sequence_pyramid[pyramid_height - index - 2].last + sequence_pyramid[pyramid_height - index - 1].last
        end
    
        sum_of_sequence_ends += sequence_pyramid.first.last
    end

    puts sum_of_sequence_ends
end

# def day_8_part_2(file_name)
# end

def get_sequences(file_name)
    sequences = []


    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            sequences << line.split(' ').map(&:to_i)
        end
    end

    return sequences
end

day_8_part_1("example.txt")
day_8_part_1("input.txt")
# day_8_part_2("example.txt")
# day_8_part_2("input.txt")