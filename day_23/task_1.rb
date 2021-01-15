require 'pry'

# cups = [3, 8, 9, 1, 2, 5, 4, 6, 7]
cups = [1, 9, 8, 7, 5, 3, 4, 6, 2]
current_cup = cups.first

100.times do
  # p current_cup, cups
  pick_up = 3.times.inject([]) do |result|
    result << (cups.delete_at(cups.index(current_cup) + 1) || cups.delete_at(0))
  end

  destination_cup = current_cup
  current_cup.times do
    destination_cup -= 1

    break if destination_cup.zero?
    break unless pick_up.include?(destination_cup)
  end

  destination_cup = destination_cup.zero? ? cups.max : destination_cup

  cups.insert(cups.index(destination_cup) + 1, *pick_up)
  current_cup = cups.fetch(cups.index(current_cup) + 1, cups.first)
end

# binding.pry;
index = cups.index(1)
p (cups[index..-1] + cups[0..index-1])[1..-1].join('')
