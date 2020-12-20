DIRECTIONS = %w(N W S E)
ROTATIONS = %w(L R)
instructions = File.read("input.txt").split("\n")

def move_waypoint(position, direction, distance)
  case direction
  when "N"
    [position[0], position[1] + distance]
  when "S"
    [position[0], position[1] - distance]
  when "E"
    [position[0] + distance, position[1]]
  when "W"
    [position[0] - distance, position[1]]
  end
end

def rotate_waypoint(position, direction, rotation)
  if direction == "R"
    ((rotation / 90) % 4).times { position = [position[1], -position[0]] }
  elsif direction == "L"
    ((rotation / 90) % 4).times { position = [-position[1], position[0]] }
  end

  position
end

ship_direction = "E"
ship_position = [0, 0]
waypoint_offset = [10, 1]

instructions.each do |instruction|
  command, value = instruction[0], instruction[1..-1].to_i

  if DIRECTIONS.include?(command)
    waypoint_offset = move_waypoint(waypoint_offset, command, value)
  elsif ROTATIONS.include?(command)
    waypoint_offset = rotate_waypoint(waypoint_offset, command, value)
  elsif command == "F"
    ship_position = [ship_position[0] + (waypoint_offset[0] * value), ship_position[1] + (waypoint_offset[1] * value)]
  end
end

p ship_position.map(&:abs).sum
