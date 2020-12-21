memory = {}
mask = {}

def masked_value(mask, value)
  mask.inject("%036b" % value) do |masked, (index, char)|
    masked[index] = char
    masked
  end.to_i(2)
end

File.readlines("input.txt").each do |line|
  instruction, value = line.split(" = ")

  if instruction == "mask"
    mask = value.chars.each_with_index.filter_map { |char, index| [index, char] if char != "X" }
    next
  end

  memory[instruction[/\d+/].to_i] = masked_value(mask, value.to_i)
end

p memory.values.sum
