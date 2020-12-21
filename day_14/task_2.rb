memory = {}
mask = {}

def masked_addresses(mask, value)
  result = mask.inject(["%036b" % value]) do |masked, (index, char)|
    if char == "1"
      masked.each { |e| e[index] = char }
    elsif char == "X"
      masked = masked.inject([]) do |result, value|
        result << value.tap { |v| v[index] = "1" }
        result << value.dup.tap { |v| v[index] = "0" }
      end
    end

    masked
  end

  result.map { |e| e.to_i(2) }
end

File.readlines("input.txt").each do |line|
  instruction, value = line.split(" = ")

  if instruction == "mask"
    mask = value.chars.each_with_index.filter_map { |char, index| [index, char] if ["1", "X"].include?(char) }
    next
  end

  masked_addresses(mask, instruction[/\d+/].to_i).each { |address| memory[address] = value.to_i }
end

p memory.values.sum
