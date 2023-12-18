module Helpers
    def self.visualize_array(array)
        array.each do |row|
            puts row.join(' ') + "\n"
        end
    end
end