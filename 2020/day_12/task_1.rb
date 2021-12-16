DIRECTIONS = %w(N W S E)
ROTATIONS = %w(L R)
instructions = File.read("input.txt").split("\n")

def next_position(position, direction, distance)
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

def next_direction(direction, rotation_direction, rotation)
  if rotation_direction == "R"
    DIRECTIONS[DIRECTIONS.index(direction) - (rotation / 90) % 4]
  elsif rotation_direction == "L"
    DIRECTIONS[DIRECTIONS.index(direction) - DIRECTIONS.length + (rotation / 90) % 4]
  end
end

ship_direction = "E"
ship_position = [0, 0]

instructions.each do |instruction|
  command, value = instruction[0], instruction[1..-1].to_i

  if DIRECTIONS.include?(command)
    ship_position = next_position(ship_position, command, value)
  elsif ROTATIONS.include?(command)
    ship_direction = next_direction(ship_direction, command, value)
  elsif command == "F"
    ship_position = next_position(ship_position, ship_direction, value)
  end
end

p ship_position.map(&:abs).sum
