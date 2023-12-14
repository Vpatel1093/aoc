TYPE_STRENGTHS = %i[five four full_house three two_pair one_pair high_card]
CARD_STRENGTHS = %w[A K Q J T 9 8 7 6 5 4 3 2]

def day_6_part_1(file_name)
    hands_and_bids = get_hands_and_bids(file_name)

    get_hand_types(hands_and_bids)
    get_hand_rankings(hands_and_bids)

    puts hands_and_bids.map {|hand| hand[1] * hand[3] }.sum
end

def get_hands_and_bids(file_name)
    hands_and_bids = []

    File.open(file_name, 'r') do |file|
        file.each_line do |line|
            # [hand, bid, type, rank]
            hands_and_bids << [line.split(" ")[0], line.split(" ")[1].to_i, nil, nil]
        end
    end

    return hands_and_bids
end

def get_hand_types(hands_and_bids)
    hands_and_bids.each_with_index do |hand, index|
        hand[2] = case hand[0].split('').tally.values.sort {|a, b| b <=> a}
        when [5]
            :five
        when [4, 1]
            :four
        when [3, 2]
            :full_house
        when [3, 1, 1]
            :three
        when [2, 2, 1]
            :two_pair
        when [2, 1, 1, 1]
            :one_pair
        when [1, 1, 1, 1, 1]
            :high_card
        end
    end
end

def get_hand_rankings(hands_and_bids)
    hands_and_bids.sort_by do |hand|
        [TYPE_STRENGTHS.index(hand[2]), hand[0].split('').map { |card| CARD_STRENGTHS.index(card) }]
    end.reverse.map.with_index do |hand, index|
        hand[3] = index + 1
    end

    puts hands_and_bids
end

day_6_part_1("example.txt")
day_6_part_1("input.txt")