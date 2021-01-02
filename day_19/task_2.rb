require 'pry'

class Rule
  @@rules = []

  attr_reader :id, :terminal

  def initialize(id, right_hand)
    @id = id.to_i
    @terminal = nil
    @non_terminals = []
    @resolve_cycle = 0

    from_string(right_hand)

    @@rules << self
  end

  def self.rules
    @@rules
  end

  def resolve
    return @terminal if @terminal

    result = non_terminals.map do |group|
      group.map do |reference|
        Rule.rules.find { |r| r.id == reference }.resolve
      end.join("")
    end

    "(#{result.join("|")})"
  end

  def non_terminals
    result = if id == 8
      @resolve_cycle == 6 ? @non_terminals : [[42], [42, 8]]
    elsif id == 11
      @resolve_cycle == 6 ? @non_terminals : [[42, 31], [42, 11, 31]]
    else
      @non_terminals
    end

    @resolve_cycle += 1

    result
  end

  def from_string(string)
    if terminal = string.match(/"([a-z])"/)
      @terminal = terminal[1]
    else
      @non_terminals = string.split(" | ").map { |e| e.split(" ").map(&:to_i) }
    end
  end
end

words = File.read("input.txt").split("\n").inject([]) do |words, line|
  if line.include?(":")
    Rule.new(*line.split(": "))
  else
    words << line
  end

  words
end

regex = "^#{Rule.rules.find { |r| r.id == 0 }.resolve}$"

p words.select { |w| w.match?(regex) }.count
