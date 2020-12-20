File.read("input.txt").split("\n\n").map do |group|
  group.split("\n").map(&:chars).reduce(:&)
end.flatten.count
