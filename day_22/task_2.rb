require 'pry'

deck1 = [9, 2, 6, 3, 1]
deck2 = [5, 8, 4, 7, 10]

deck1 = [44, 24, 36, 6, 27, 46, 33, 45, 47, 41, 15, 23, 40, 38, 43, 42, 25, 5, 30, 35, 34, 13, 29, 1, 50]
deck2 = [32, 28, 4, 12, 9, 21, 48, 18, 31, 39, 20, 16, 3, 37, 49, 7, 17, 22, 8, 26, 2, 14, 11, 19, 10]

class Game
  attr_reader :deck1, :deck2, :history

  def initialize(deck1, deck2)
    @deck1 = deck1
    @deck2 = deck2
    @history = []
  end

  def winner
    deck1.empty? ? 2 : 1
  end

  def winning_deck
    deck1.empty? ? deck2 : deck1
  end

  def history_repeated?
    history.include?("#{deck1.join(',')}|#{deck2.join(',')}")
  end

  def update_history!
    history << "#{deck1.join(',')}|#{deck2.join(',')}"
  end

  def play!
    until deck1.empty? || deck2.empty?
      if history_repeated?
        deck1.push(deck1.shift, deck2.shift)
        return
      end

      update_history!

      card1 = deck1.shift
      card2 = deck2.shift

      if deck1.length >= card1 && deck2.length >= card2
        recursive_game = self.class.new(deck1.dup.take(card1), deck2.dup.take(card2))
        recursive_game.play!
        recursive_game.winner == 1 ? deck1.push(card1, card2) : deck2.push(card2, card1)
      else
        card1 > card2 ? deck1.push(card1, card2) : deck2.push(card2, card1)
      end
    end
  end
end

game = Game.new(deck1, deck2)
game.play!
p game.winning_deck.reverse.each_with_index.reduce(0) { |sum,  (card, index)| sum + (index + 1) * card }
