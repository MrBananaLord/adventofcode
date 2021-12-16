STARTING_NUMBERS = [0,1,5,10,3,12,19]

numbers = Hash[STARTING_NUMBERS.each_with_index.map do |number, index|
  [number, index + 1]
end]

result = ((STARTING_NUMBERS.length + 2)..30000000).inject(0) do |previous_number, turn|
  if numbers[previous_number]
    next_number = turn - 1 - numbers[previous_number]
    numbers[previous_number] = turn - 1
    previous_number = next_number
  else
    numbers[previous_number] = turn - 1
    previous_number = 0
  end

  previous_number
end

p result
