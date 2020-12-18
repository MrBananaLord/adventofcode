$jolts = File.read("input.txt").split("\n").map(&:to_i).sort
$jolts.unshift(0)
$jolts.push($jolts.max + 3)

def candidates(index)
  3.times.filter_map do |i|
    $jolts[index] + i + 1 if $jolts.include?($jolts[index] + i + 1)
  end
end

candidate_hash = Hash[$jolts.map { |e| [e, candidates($jolts.index(e))] }]
candidate_count = candidate_hash.values.map(&:count)

count = 1
permutations = [1, 4, 7]
index = 0

loop do
  if candidate_count[index] == 3
    i = index
    i+= 1 while candidate_count[i + 1] > 1

    count *= permutations[i - index]
    index = i
  elsif candidate_count[index] == 2
    count *= 2
  end

  index += 1
  break if index > candidate_count.length
end

p count
