DIRECTIONS = [[0, 1], [0, -1], [1, 0], [1, 1], [1, -1], [-1, 0], [-1, 1], [-1, -1]]
places = File.read("input.txt").split("\n").map { |line| line.split("") }

def visible_seats(places, starting_row_index, starting_column_index)
  DIRECTIONS.map do |row_offset, column_offset|
    distance = 1

    loop do
      row_index = starting_row_index + (row_offset * distance)
      column_index = starting_column_index + (column_offset * distance)

      break if row_index < 0 || row_index >= places.size || column_index < 0 || column_index >= places[row_index].length

      place = places[row_index][column_index]

      break [row_index, column_index] if place != "."

      distance += 1
    end
  end.compact
end

$visible_seats = places.each_with_index.map do |row, row_index|
  row.each_with_index.map do |place, column_index|
    visible_seats(places, row_index, column_index)
  end
end

def visible_place_states(places, row_index, column_index)
  $visible_seats[row_index][column_index].map do |row, column|
    places[row][column]
  end
end

def next_places(places)
  next_places = places.each_with_index.map do |row, row_index|
    row.each_with_index.map do |place, column_index|
      if place == "L"
        next "#" if visible_place_states(places, row_index, column_index).count { |i| i == "#" } == 0
      elsif place == "#"
        next "L" if visible_place_states(places, row_index, column_index).count { |i| i == "#" } >= 5
      end

      place
    end
  end

  return next_places(next_places) if next_places != places

  next_places
end

require 'benchmark'

time = Benchmark.measure {
  places = next_places(places)
}

sum = places.reduce(0) do |sum,row|
  sum += row.count { |e| e == "#" }
end
p sum
p time.real
