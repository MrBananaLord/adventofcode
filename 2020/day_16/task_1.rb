rules = {}
tickets = []

mode = :rules

File.readlines("input.txt").each do |line|
  next mode = :ignore if line == "\n"
  next mode = :tickets if line == "nearby tickets:\n"

  if mode == :rules
    rule, ranges = line.split(": ")
    rules[rule] = ranges.split(" or ").map { |e| Range.new(*e.split("-").map(&:to_i)) }
  elsif mode == :tickets
    tickets << line.split(",").map(&:to_i)
  end
end

invalid_values = tickets.inject(0) do |sum, ticket|
  ticket.each do |value|
    next if rules.values.any? { |ranges| ranges.any? { |range| range.include?(value) } }

    sum += value
  end

  sum
end

p invalid_values
