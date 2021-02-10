DIRECTIONS = ["N", "W", "S", "E"]
ROTATIONS = ["L", "R"]

def move_waypoint(position, direction, distance):
  if direction == "N":
    return [position[0], position[1] + distance]
  elif direction == "S":
    return [position[0], position[1] - distance]
  elif direction == "E":
    return [position[0] + distance, position[1]]
  elif direction == "W":
    return [position[0] - distance, position[1]]

def rotate_waypoint(position, direction, rotation):
  if direction == "R":
    for _ in range(int((rotation / 90) % 4)):
      position = [position[1], -position[0]]
  elif direction == "L":
    for _ in range(int((rotation / 90) % 4)):
      position = [-position[1], position[0]]
      
  return position

ship_direction = "E"
ship_position = [0, 0]
waypoint_offset = [10, 1]

file = open("input.txt", "r")

for instruction in file.readlines():
  instruction = instruction.strip("\n")
  command, value = instruction[0], int(instruction[1:])

  if command in DIRECTIONS:
    waypoint_offset = move_waypoint(waypoint_offset, command, value)
  elif command in ROTATIONS:
    waypoint_offset = rotate_waypoint(waypoint_offset, command, value)
  elif command == "F":
    ship_position = [ship_position[0] + (waypoint_offset[0] * value), ship_position[1] + (waypoint_offset[1] * value)]


file.close()

print(sum(map(abs, ship_position)))
