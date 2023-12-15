def day_8(file_name, jokers_wild = false)
    lr, mapping = get_lr_and_mapping(file_name)
    curr = "AAA"
    steps = 0
    orig_lr = lr.dup

    until curr == "ZZZ"
        curr = mapping[curr][lr.slice!(0)]

        lr = orig_lr.dup if lr.empty?
        steps += 1
    end

    puts steps
end

def get_lr_and_mapping(file_name)
    lr = ""
    mapping = {}

    File.open(file_name, 'r') do |file|
        lr = file.readline.chomp
        file.readline
        
        file.each_line do |line|
            key = line[0..2]

            mapping[key] = { 'L' => line[7..9], 'R' => line[12..14] }
        end
    end

    return lr, mapping
end

day_8("example1.txt", false)
day_8("example2.txt", false)
day_8("input.txt", false)