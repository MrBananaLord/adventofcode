require 'pry'

class Rule
  @@rules = []

  attr_reader :id, :non_terminals, :terminal

  def initialize(id, right_hand)
    @id = id.to_i
    @terminal = nil
    @non_terminals = []

    from_string(right_hand)

    @@rules << self
  end

  def self.rules
    @@rules
  end

  def resolve
    return @terminal if @terminal

    result = @non_terminals.map do |group|
      group.map do |reference|
        Rule.rules.find { |r| r.id == reference }.resolve
      end.join("")
    end

    "(#{result.join("|")})"
  end

  def from_string(string)
    if terminal = string.match(/"([a-z])"/)
      @terminal = terminal[1]
    else
      @non_terminals = string.split(" | ").map { |e| e.split(" ").map(&:to_i) }
    end
  end
end

matches = File.read("input.txt").split("\n").inject([]) do |matches, line|
  if line.include?(":")
    Rule.new(*line.split(": "))
  else
    $regex ||= "^#{Rule.rules.find { |r| r.id == 0 }.resolve}$"
    matches << line if line.match?($regex)
  end

  matches
end

rule_zero = Rule.rules.find { |r| r.id == 0 }

p matches.count
