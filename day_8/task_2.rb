instructions = File.read("input.txt").split("\n").each_with_index.map do |instruction, index|
  type, value = instruction.split(" ")
  {
    index: index,
    type: type,
    value: value.to_i
  }
end

def run_instructions(instructions, index, instruction_history = [])
  instruction = instructions[index]

  # pp [index, instruction]
  return if instruction.nil?
  return if instruction_history.include?(index)

  instruction_history << index

  case instruction[:type]
  when "nop"
    run_instructions(instructions, index + 1, instruction_history)
  when "acc"
    run_instructions(instructions, index + 1, instruction_history)
  when "jmp"
    run_instructions(instructions, index + instruction[:value], instruction_history)
  end

  instruction_history
end

run_history = run_instructions(instructions, 0)
run_history.pop

loop do
  index = run_history.pop

  next if instructions[index][:type] == "acc"

  modified_instructions = instructions.dup.tap do |i|
    case i[index][:type]
    when "nop"
      i[index][:type] = "jmp"
    when "jmp"
      i[index][:type] = "nop"
    end
  end

  result = run_instructions(modified_instructions, index)

  if result.last == instructions.length - 1
    p "BROKEN INDEX: #{index}"
    result = run_instructions(modified_instructions, 0)
    p result
    sum = result.reduce(0) do |sum, index|
      if instructions[index][:type] == "acc"
        sum += instructions[index][:value]
      else
        sum
      end
    end
    p sum
    break
  end
end
