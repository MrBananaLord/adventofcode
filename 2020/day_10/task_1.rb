
$jolts = File.read("input.txt").split("\n").map(&:to_i).sort
$jolts << $jolts.max + 3
$path = []
$counters = {
  1 => 0,
  2 => 0,
  3 => 0
}

def jolts_path(current_jolt)
  3.times.find do |i|
    next unless $jolts.include?(current_jolt + i + 1)

    $path << current_jolt + i + 1
    $counters[i + 1] += 1

    # p "3 => cj: #{current_jolt}, nj: #{current_jolt + i + 1}" if i + 1 == 3

    jolts_path(current_jolt + i + 1)

    break
  end
end

jolts_path(0)
p $path
p $counters

p $counters[1] * $counters[3]
