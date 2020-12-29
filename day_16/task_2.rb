rules = []
tickets = []
my_ticket = nil

mode = :rules

class Rule
  attr_reader :name, :ranges

  def initialize(name, ranges)
    @name = name
    @ranges = ranges
  end

  def valid?(value)
    ranges.any? { |range| range.include?(value) }
  end
end

File.readlines("input.txt").each do |line|
  next mode = :ignore if line == "\n"
  next mode = :my_ticket if line == "your ticket:\n"
  next mode = :tickets if line == "nearby tickets:\n"

  if mode == :rules
    rule, ranges = line.split(": ")
    rules << Rule.new(rule, ranges.split(" or ").map { |e| Range.new(*e.split("-").map(&:to_i)) })
  elsif mode == :tickets
    tickets << line.split(",").map(&:to_i)
  elsif mode == :my_ticket
    my_ticket = line.split(",").map(&:to_i)
  end
end

def valid_ticket?(ticket, rules)
  ticket.all? do |value|
    rules.any? do |rule|
      rule.valid?(value)
    end
  end
end

candidates = tickets.first.length.times.map { rules.dup }

tickets.each do |ticket|
  next unless valid_ticket?(ticket, rules)

  ticket.each_with_index do |value, index|
    candidates[index].select! { |rule| rule.valid?(value) }
  end
end

known_fields = []

while known_fields.compact.length < candidates.length
  candidates.each_with_index do |rules, index|
    rules.reject! { |rule| known_fields.include?(rule.name) }

    if rules.length == 1
      known_fields[index] = rules.first.name
      candidates[index] = []
    end
  end
end

p known_fields.zip(my_ticket).filter_map { |e| e[1] if e[0].start_with?("departure") }.reduce(:*)
