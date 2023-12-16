def day_8(file_name, extrapolate_backwards)
    sequences = get_sequences(file_name)
    extrapolation_total = 0

    sequences.each do |sequence|
        sequence_pyramid = [sequence]

        until sequence_pyramid.last.all? { |element| element == 0 }
            new_row = Array.new(sequence_pyramid.last.length - 1, nil)
            new_row = new_row.map.with_index { |element, index| element = sequence_pyramid.last[index + 1] - sequence_pyramid.last[index] }
            sequence_pyramid << new_row
        end
    
        pyramid_height = sequence_pyramid.length
        (pyramid_height - 1).times do |index|
            if extrapolate_backwards
                sequence_pyramid[pyramid_height - index - 2] <<  sequence_pyramid[pyramid_height - index - 2].last + sequence_pyramid[pyramid_height - index - 1].last
            else
                sequence_pyramid[pyramid_height - index - 2].unshift(sequence_pyramid[pyramid_height - index - 2].first - sequence_pyramid[pyramid_height - index - 1].first)
            end
        end
    
        extrapolation_total += extrapolate_backwards ? sequence_pyramid.first.last : sequence_pyramid.first.first
    end

    puts extrapolation_total
end

def get_sequences(file_name)
    sequences = []


    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            sequences << line.split(' ').map(&:to_i)
        end
    end

    return sequences
end

day_8("example.txt", true)
day_8("input.txt", true)
day_8("example.txt", false)
day_8("input.txt", false)