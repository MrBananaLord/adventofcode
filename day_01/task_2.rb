SUM_TARGET = 2020

def find_by_sum_target(elements, sum_target)
  elements.inject([]) do |diffs, entry|
    return [entry, (sum_target - entry)] if diffs.include?(entry)

    diffs << sum_target - entry
  end

  return nil
end

entries = File.read("input.txt").split("\n")
result = nil

diffs = entries.inject({}) do |diffs, entry|
  entry = entry.to_i
  diff  = SUM_TARGET - entry

  diffs[entry] = diff

  diffs
end

diffs.each do |entry, diff|
  if result = find_by_sum_target(diffs.keys, diff)
    result << entry

    break
  end
end

pp result, result.reduce(&:*)
