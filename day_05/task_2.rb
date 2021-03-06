cards = File.read("input.txt").split("\n")

def code_to_number(string)
  string.split("").each_with_index.inject(0) do |sum, (letter, index)|
    sum += 2 ** (string.length - index - 1) if %w(B R).include?(letter)

    sum
  end
end

result = cards.map do |card|
  row = code_to_number(card.slice(0,7))
  column = code_to_number(card.slice(7,3))

  {
    row: row,
    column: column,
    id: row * 8 + column
  }
end

seat = result.group_by { |e| e[:row] }.filter_map do |row, seats|
  next if seats.count == 8

  full_ids = seats.map { |s| s[:id] }
  candidate_ids = ((row * 8)..(row * 8 + 7)).to_a - full_ids

  candidate_ids.find do |id|
    full_ids.include?(id - 1) && full_ids.include?(id + 1)
  end
end.first

pp seat
