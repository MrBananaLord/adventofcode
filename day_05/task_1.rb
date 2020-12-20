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

pp result.map { |e| e[:id] }.max
