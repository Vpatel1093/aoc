INPUTS = []
File.open('input.txt', 'r') do |file|
    # Read each line from the file and add it to the array
    file.each_line do |line|
        INPUTS << line.chomp
    end
end
WRITTEN_DIGITS = %w[zero one two three four five six seven eight nine]
STR_TO_INT_HASH = {
  'zero'  => 0,
  'one'   => 1,
  'two'   => 2,
  'three' => 3,
  'four'  => 4,
  'five'  => 5,
  'six'   => 6,
  'seven' => 7,
  'eight' => 8,
  'nine'  => 9,
  'ten'   => 10
}

def part_1
    sum = 0

    INPUTS.each do |input|
        # get index of first char that is a digit
        first_digit_index = input =~ /\d/
        second_digit_index = input.rindex(/\d/)

        sum += "#{input[first_digit_index]}#{input[second_digit_index]}".to_i
    end

    return sum
end

def part_2
    sum = 0

    INPUTS.each do |input|
        first_digit_index = 99999
        first_digit = 0
        second_digit_index = 0
        second_digit = 0
        WRITTEN_DIGITS.each do |written_digit|
            digit_as_string_first_index = input.index(written_digit) || 99999
            if digit_as_string_first_index <= first_digit_index
                first_digit = STR_TO_INT_HASH[written_digit]
                first_digit_index = digit_as_string_first_index
            end

            digit_as_string_last_index = input.rindex(written_digit) || -1
            if digit_as_string_last_index >= second_digit_index
                second_digit = STR_TO_INT_HASH[written_digit]
                second_digit_index = digit_as_string_last_index
            end
        end
        

        digit_as_int_first_index = input =~ /\d/ || 99999
        if digit_as_int_first_index < first_digit_index
            first_digit = input[digit_as_int_first_index]
            first_digit_index = digit_as_int_first_index
        end
        digit_as_int_last_index = input.rindex(/\d/)
        if digit_as_int_last_index
            if digit_as_int_last_index >= second_digit_index
                second_digit = input[digit_as_int_last_index]
            end
        end

        sum += "#{first_digit}#{second_digit}".to_i
    end

    return sum
end

puts part_1
puts part_2
