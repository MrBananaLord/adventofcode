file = open("input.txt", "r")

depth = 0
horizontal_position = 0
aim = 0

for line in file.readlines():
  command, value = line.strip("\n").split(" ")
  value = int(value)

  if command == "forward":
    horizontal_position += value
    depth += aim * value
  if command == "down":
    aim += value
  if command == "up":
    aim -= value
      
print(abs(depth * horizontal_position))
