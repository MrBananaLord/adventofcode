TARGET_NUMBER = 88311122
# TARGET_NUMBER = 127

numbers = File.read("input.txt").split("\n").map(&:to_i)

loop do
  i = 2
  i += 1 while (sum = numbers.slice(0, i).sum) < TARGET_NUMBER

  # p i, numbers
  if sum == TARGET_NUMBER
    p numbers.slice(0, i).max + numbers.slice(0, i).min
    break
  end

  numbers.shift
end
