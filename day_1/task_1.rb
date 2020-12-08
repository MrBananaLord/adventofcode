SUM_TARGET = 2020

result = nil
entries = File.read("input.txt").split("\n").map(&:to_i)

entries.inject([]) do |diffs, entry|
  if diffs.include?(entry)
    result = entry * (SUM_TARGET - entry)
    break
  end

  diffs << SUM_TARGET - entry
end

print result
