TYPE_STRENGTHS = %i[five four full_house three two_pair one_pair high_card]
CARD_STRENGTHS = %w[A K Q J T 9 8 7 6 5 4 3 2]
CARD_STRENGTHS_WITH_JOKERS_WILD = %w[A K Q T 9 8 7 6 5 4 3 2 J]

def day_7(file_name, jokers_wild = false)
    hands_and_bids = get_hands_and_bids(file_name)

    get_hand_types(hands_and_bids, jokers_wild)
    get_hand_rankings(hands_and_bids, jokers_wild)

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

def get_hand_types(hands_and_bids, jokers_wild = false)
    hands_and_bids.each_with_index do |hand, index|
        j_count = 0
    
        hand_card_tally = hand[0].split('').tally
        if hand_card_tally['J'] && jokers_wild
            j_count = hand_card_tally['J']
            hand_card_tally.delete('J')
        end
        hand_card_counts_sorted = hand_card_tally.values.sort {|a, b| b <=> a}

        if jokers_wild
            if j_count == 5
                hand_card_counts_sorted << 5
            else    
                hand_card_counts_sorted[0] += j_count 
            end
        end
        
        hand[2] = case hand_card_counts_sorted
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

def get_hand_rankings(hands_and_bids, jokers_wild = false)
    hands_and_bids.sort_by do |hand|
        [TYPE_STRENGTHS.index(hand[2]), hand[0].split('').map { |card| jokers_wild ? CARD_STRENGTHS_WITH_JOKERS_WILD.index(card) : CARD_STRENGTHS.index(card) }]
    end.reverse.map.with_index do |hand, index|
        hand[3] = index + 1
    end

    puts hands_and_bids
end

day_7("example.txt", false)
day_7("input.txt", false)
day_7("example.txt", true)
day_7("input.txt", true)