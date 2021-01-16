require 'pry'

PICK_UP_SIZE = 3
ROUNDS = 10_000_000
DEBUG = false

CUPS = [3, 8, 9, 1, 2, 5, 4, 6, 7] + (10..1_000_000).to_a
# CUPS = [1, 9, 8, 7, 5, 3, 4, 6, 2] + (10..1_000_000).to_a

class Cup
  attr_reader :value
  attr_accessor :next_cup, :current

  def initialize(value)
    @value = value
    @current = false
    @destination_candidate_values = [value - 1, value - 2, value - 3, value - 4]

    self.class.add(self)
  end

  def self.all
    @all ||= {}
  end

  def self.add(cup)
    all[cup.value] = cup
  end

  def self.max_candidate_values
    @max_candidate_values ||= all.keys.max(4)
  end

  def find(value)
    self.class.all[value]
  end

  def pick_up!
    cup3 = next_cup.next_cup.next_cup
    result = [next_cup, next_cup.next_cup, cup3].map(&:value)
    self.next_cup = cup3.next_cup
    result
  end

  def destination_cup(pick_up_values)
    destination_cup_value = (@destination_candidate_values - pick_up_values).first

    if destination_cup_value.zero?
      find((self.class.max_candidate_values - pick_up_values).first)
    else
      find(destination_cup_value)
    end
  end

  def insert!(pick_up_values)
    find(pick_up_values.last).next_cup = next_cup
    self.next_cup = find(pick_up_values.first)
  end

  def current?
    !!@current
  end

  def move_current!
    self.current = false
    next_cup.current = true
    next_cup
  end

  def to_s
    current? ? "(#{value})" : " #{value} "
  end

  def inspect
    {
      class: self.class,
      value: value,
      current: current?,
      next_cup: next_cup.value
    }
  end

  def pretty_cups(offset)
    cups = ordered_cups

    (cups[cups.count - offset..-1] + cups[0..cups.count - offset - 1]).join('')
  end

  def ordered_cups
    result = [self]
    child = next_cup

    until child.current?
      result << child
      child = child.next_cup
    end
    result
  end
end

previous_cup = nil
Hash[CUPS.map do |value|
  cup = Cup.new(value)
  previous_cup.next_cup = cup if previous_cup
  previous_cup = cup

  [value, cup]
end]

current_cup = Cup.all.values.first
current_cup.current = true
Cup.all.values.last.next_cup = current_cup

ROUNDS.times do |x|
  if x % 1_000_000 == 0
    p x
  end
  print("-- move #{x + 1} --\ncups: #{current_cup.pretty_cups(x % Cup.all.count)}\n") if DEBUG

  pick_up = current_cup.pick_up!
  print("pick up: #{pick_up}\n") if DEBUG

  destination_cup = current_cup.destination_cup(pick_up)
  print("destination: #{destination_cup.value}\n") if DEBUG

  destination_cup.insert!(pick_up)
  current_cup = current_cup.move_current!

  print("\n") if DEBUG
end

print("-- final --\ncups: #{current_cup.pretty_cups(ROUNDS % Cup.all.count)}\n") if DEBUG
print(Cup.all[1].next_cup.value * Cup.all[1].next_cup.next_cup.value)
