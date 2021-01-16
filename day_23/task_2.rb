require 'pry'

PICK_UP_SIZE = 3

cups = [3, 8, 9, 1, 2, 5, 4, 6, 7] # + (10..50).to_a
# cups = [1, 9, 8, 7, 5, 3, 4, 6, 2] + (10..1_000_000).to_a

current_cup_index = 0
cups_count = cups.length
max_candidates = cups.max(4)

10.times do |x|
  # p x if (x % 100 == 0)
  # print("round #{x + 1}\ncurrent = (#{cups[current_cup_index]})\ncups = #{cups}\n")

  pick_up = if (current_cup_index + PICK_UP_SIZE) >= cups_count
    cups_to_end_count = cups[current_cup_index + 1..-1].count
    current_cup_index -= 3 - cups_to_end_count

    cups.pop(cups_to_end_count) + cups.shift(3 - cups_to_end_count)
  else
    cups.slice!(current_cup_index + 1, PICK_UP_SIZE)
  end

  # print("pick up = #{pick_up}\n")
  value = cups[current_cup_index]
  candidates = [value - 1, value - 2, value - 3, value - 4]
  destination_cup_value = (candidates - pick_up).first
  destination_cup_value = destination_cup_value.zero? ? (max_candidates - pick_up).first : destination_cup_value
  destination_cup_index = cups.index(destination_cup_value)
  # print("destination = #{destination_cup_value}\n\n")

  # binding.pry;
  cups.insert(destination_cup_index + 1, *pick_up)
  current_cup_index += 3 if destination_cup_index < current_cup_index

  current_cup_index = (current_cup_index + 1) >= cups_count ? 0 : current_cup_index + 1
end

# binding.pry;
index = cups.index(1)
p (cups[index..-1] + cups[0..index-1])[1..-1].join('')
