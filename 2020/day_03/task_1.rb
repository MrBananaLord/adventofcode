rows = File.read("input.txt").split("\n")

x = 0
count = rows.inject(0) do |tree_count, row|
  tree_count += 1 if row[x] == "#"

  x = (x + 3) % row.length

  tree_count
end

pp count
