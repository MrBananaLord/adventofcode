cards = File.read("input.txt").split("\n")

def parse_code(string)
  string.split("").inject(0..(2 ** string.length - 1)) do |position, letter|
    if %w(F L).include?(letter)
      position = position.first..(position.last - (position.count / 2))
    elsif %w(B R).include?(letter)
      position = (position.first + (position.count / 2))..position.last
    end

  end.first
end

result = cards.map do |card|
  row = parse_code(card.slice(0,7))
  column = parse_code(card.slice(7,3))

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

pp seats
