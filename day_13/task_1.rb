timestamp, lines = File.read("input.txt").split("\n")
lines = lines.split(",").filter_map { |e| e.to_i if e != "x" }

wait_time_for_lines = lines.map do |line|
  [line, line - timestamp.to_i % line]
end

p wait_time_for_lines.min { |a, b| a[1] <=> b[1]  }.reduce(:*)

