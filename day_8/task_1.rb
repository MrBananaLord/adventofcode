$instructions = File.read("input.txt").split("\n").map do |instruction|
  type, value = instruction.split(" ")
  {
    type: type,
    value: value.to_i
  }
end

$accumulator = 0

def run_instructions(instruction_index)
  instruction = $instructions[instruction_index]

  p instruction_index, instruction
  return if instruction.nil?
  return if instruction[:executed]

  instruction[:executed] = true

  case instruction[:type]
  when "nop"
    run_instructions(instruction_index + 1)
  when "acc"
    $accumulator += instruction[:value]
    run_instructions(instruction_index + 1)
  when "jmp"
    run_instructions(instruction_index + instruction[:value])
  end
end

run_instructions(0)

p $accumulator
