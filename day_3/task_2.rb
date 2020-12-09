rows = File.read("input.txt").split("\n")

traverses = [
  {
    right: 1,
    down:  1,
    trees: 0,
    x:     0,
    y:     0
  },
  {
    right: 3,
    down:  1,
    trees: 0,
    x:     0,
    y:     0
  },
  {
    right: 5,
    down:  1,
    trees: 0,
    x:     0,
    y:     0
  },
  {
    right: 7,
    down:  1,
    trees: 0,
    x:     0,
    y:     0
  },
  {
    right: 1,
    down:  2,
    trees: 0,
    x:     0,
    y:     0
  }
]

row_length = rows.first.length

rows.each_with_index do |row, index|
  traverses.each do |traverse|
    next unless traverse[:y] == index

    traverse[:trees] += 1 if row[traverse[:x]] == "#"

    traverse[:x] = (traverse[:x] + traverse[:right]) % row_length
    traverse[:y] += traverse[:down]
  end
end

pp traverses, traverses.map { |t| t[:trees] }.reduce(&:*)
