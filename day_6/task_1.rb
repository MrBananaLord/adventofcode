File.read("input.txt").split("\n\n").reduce(0) do |sum, group|
  sum + group.split("\n").map(&:chars).flatten.uniq.count
end
