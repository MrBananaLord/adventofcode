DIRECTIONS = ["N", "W", "S", "E"]
ROTATIONS = ["L", "R"]

def next_position(position, direction, distance):
  if direction == "N":
    return [position[0], position[1] + distance]
  elif direction == "S":
    return [position[0], position[1] - distance]
  elif direction == "E":
    return [position[0] + distance, position[1]]
  elif direction == "W":
    return [position[0] - distance, position[1]]

def next_direction(direction, rotation_direction, rotation):
  if rotation_direction == "R":
    return DIRECTIONS[DIRECTIONS.index(direction) - int((rotation / 90) % 4)]
  elif rotation_direction == "L":
    return DIRECTIONS[DIRECTIONS.index(direction) - len(DIRECTIONS) + int((rotation / 90) % 4)]

ship_direction = "E"
ship_position = [0, 0]

file = open("input.txt", "r")

for instruction in file.readlines():
  instruction = instruction.strip("\n")
  command, value = instruction[0], int(instruction[1:])

  if command in DIRECTIONS:
    ship_position = next_position(ship_position, command, value)
  elif command in ROTATIONS:
    ship_direction = next_direction(ship_direction, command, value)
  elif command == "F":
    ship_position = next_position(ship_position, ship_direction, value)

file.close()

print(sum(map(abs, ship_position)))
