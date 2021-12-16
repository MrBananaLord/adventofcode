PREAMBLE_LENGTH = 25

numbers = File.read("input.txt").split("\n").map(&:to_i)

validation_set = numbers.slice!(0, PREAMBLE_LENGTH)

loop do
  number = numbers.shift
  sums = validation_set.combination(2).to_a.map(&:sum)

  unless sums.include?(number)
    p number
    break
  end

  validation_set.shift
  validation_set.push(number)
end
