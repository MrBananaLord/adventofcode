_timestamp, lines = File.read("input.txt").split("\n")
lines = lines.split(",").each_with_index.filter_map do |line, index|
  next if line == "x"

  [line.to_i, index]
end

lines = Hash[lines.sort.reverse]

timestamp = lines.keys.max - lines[lines.keys.max]
offset = lines.keys.max
streak = 1
streak_timestamp = 0

loop do
  if lines.first(streak + 1).all? { |line, index| (timestamp + index) % line == 0 }
    break if streak + 1 == lines.length

    if streak_timestamp == 0
      streak_timestamp = timestamp
    else
      offset = timestamp - streak_timestamp
      p [streak, offset]
      streak_timestamp = 0
      streak += 1
    end
  end

  timestamp += offset
end

p timestamp
