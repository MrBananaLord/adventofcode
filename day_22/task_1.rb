require 'pry'

deck1 = [9, 2, 6, 3, 1]
deck2 = [5, 8, 4, 7, 10]

deck1 = [44, 24, 36, 6, 27, 46, 33, 45, 47, 41, 15, 23, 40, 38, 43, 42, 25, 5, 30, 35, 34, 13, 29, 1, 50]
deck2 = [32, 28, 4, 12, 9, 21, 48, 18, 31, 39, 20, 16, 3, 37, 49, 7, 17, 22, 8, 26, 2, 14, 11, 19, 10]

until deck1.empty? || deck2.empty?
  card1 = deck1.shift
  card2 = deck2.shift

  if card1 > card2
    deck1.push(card1)
    deck1.push(card2)
  else
    deck2.push(card2)
    deck2.push(card1)
  end
end

winning_deck = deck1.empty? ? deck2 : deck1

p winning_deck.reverse.each_with_index.reduce(0) { |sum,  (card, index)| sum + (index + 1) * card }
