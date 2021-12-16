file = open("input.txt", "r")

depth = 0
horizontal_position = 0

for line in file.readlines():
  command, value = line.strip("\n").split(" ")
  value = int(value)

  if command == "forward":
    horizontal_position += value
  if command == "down":
    depth -= value
  if command == "up":
    depth += value
      
print(abs(depth * horizontal_position))
