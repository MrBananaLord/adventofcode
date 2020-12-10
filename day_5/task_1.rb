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

pp result.map { |e| e[:id] }.max
