require 'pry'

sum = File.read("input.txt").split("\n").inject(0) do |sum, line|
  stack = []

  line.chars.each do |char|
    next if char == " "

    if %w[* + (].include?(char)
      stack.push(char)
    elsif char == ")"
      until stack[-2] == "(" do
        stack.push(stack.pop.public_send(stack.pop, stack.pop))
      end

      stack.delete_at(-2)

      if stack[-2] == "+"
        stack.push(stack.pop.public_send(stack.pop, stack.pop))
      end
    else
      if stack.last == "+"
        stack.push(char.to_i.public_send(stack.pop, stack.pop))
      else
        stack.push(char.to_i)
      end
    end
  end

  until stack.length == 1 do
    stack.push(stack.pop.public_send(stack.pop, stack.pop))
  end

  sum += stack.first
end

p sum
