jolts = File.read("input.txt").split("\n").map(&:to_i).sort
jolts.unshift(0)
jolts.push(jolts.max + 3)

paths = { 0 => 1 }
jolts.each_with_index do |jolt|
  3.times.each do |i|
    candidate = jolt + i + 1

    paths[candidate] = paths[candidate].to_i + paths[jolt].to_i if jolts.include?(candidate)
  end
end

p paths[jolts.max]
