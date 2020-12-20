NEIGHBORS_OFFSET = [[0, 1], [0, -1], [1, 0], [1, 1], [1, -1], [-1, 0], [-1, 1], [-1, -1]]
places = File.read("test_input.txt").split("\n").map { |line| line.split("") }

def adjacent_places(places, row_index, column_index)
  NEIGHBORS_OFFSET.filter_map do |row_offset, column_offset|
    next if row_index + row_offset < 0 ||
            row_index + row_offset > places.length - 1 ||
            column_index + column_offset < 0 ||
            column_index + column_offset > places.first.length - 1

    places[row_index + row_offset][column_index + column_offset]
  end
end

def next_places(places)
  next_places = places.each_with_index.map do |row, row_index|
    row.each_with_index.map do |place, column_index|
      if place == "L"
        next "#" if adjacent_places(places, row_index, column_index).count { |i| i == "#" } == 0
      elsif place == "#"
        next "L" if adjacent_places(places, row_index, column_index).count { |i| i == "#" } >= 4
      end

      place
    end
  end

  return next_places(next_places) if next_places != places

  next_places
end

places = next_places(places)
# places.map do |row|
#   p row.join
# end

sum = places.reduce(0) do |sum,row|
  sum += row.count { |e| e == "#" }
end
p sum
