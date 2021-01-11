require 'pry'

SEA_MONSTER_HASH_COUNT = 15
SEA_MONSTER = {
  /(?=(..................(#|0).))/ => [18],
  /(?=((#|0)....(#|0)(#|0)....(#|0)(#|0)....(#|0)(#|0)(#|0)))/ => [0, 5, 6, 11, 12, 17, 18, 19],
  /(?=(.(#|0)..(#|0)..(#|0)..(#|0)..(#|0)..(#|0)...))/ => [1, 4, 7, 10, 13, 16]
}.freeze

class Tile
  attr_reader :unmatched_borders, :id, :matrix

  def initialize(id, matrix)
    @id = id
    @matrix = matrix
  end

  def match_neighbors!(tiles)
    return if @matched

    @matched = true
    new_neighbors = []

    borders.each do |border, neighbor|
      next if neighbor

      new_neighbor = tiles.find do |tile|
        next if tile == self

        tile.find_border(border)
      end

      next unless new_neighbor

      fit_neighbor!(new_neighbor, border)
      new_neighbors << new_neighbor
    end

    new_neighbors.each { |neighbor| neighbor.match_neighbors!(tiles) }
  end

  def properly_positioned?(tiles)
    borders.map do |border, id|
      next true if id.nil?

      neighbor = tiles.find { |n| n.id == id }

      next :reversed unless neighbor.borders.key?(border)
      next :malpositioned unless border_position(border) == opposite(neighbor.border_position(border))

      true
    end
  end

  def fit_neighbor!(other, border)
    borders[border] = other.id
    other.borders.key?(border) ? other.borders[border] = id : other.borders[border.reverse] = id
    other.fit_border!(border, opposite(border_position(border)))

    other
  end

  def match_border!(border)
    return if borders.key?(border)

    if borders.keys[0].reverse == border || borders.keys[2].reverse == border
      flip_horizontally!
    else
      flip_vertically!
    end
  end

  def fit_border!(border, side)
    match_border!(border)

    return if side == border_position(border)

    if side == opposite(border_position(border))
      %i[top bottom].include?(side) ? flip_vertically! : flip_horizontally!
    elsif side == left_from(border_position(border))
      rotate_left!
    elsif side == right_from(border_position(border))
      rotate_right!
    end

    match_border!(border)
  end

  def flip_vertically!
    @matrix = @matrix.reverse
    @borders = {
      @matrix.first => borders.values[2],
      @matrix.map(&:last) => borders.values[1],
      @matrix.last => borders.values[0],
      @matrix.map(&:first) => borders.values[3]
    }
  end

  def flip_horizontally!
    @matrix = @matrix.map(&:reverse)
    @borders = {
      @matrix.first => borders.values[0],
      @matrix.map(&:last) => borders.values[3],
      @matrix.last => borders.values[2],
      @matrix.map(&:first) => borders.values[1]
    }
  end

  def rotate_left!
    @matrix = @matrix.each_with_object([]) do |row, result|
      row.each_with_index do |element, index|
        result[row.length - 1 - index] ||= []
        result[row.length - 1 - index] << element
      end
    end

    @borders = {
      @matrix.first => borders.values[1],
      @matrix.map(&:last) => borders.values[2],
      @matrix.last => borders.values[3],
      @matrix.map(&:first) => borders.values[0]
    }
  end

  def rotate_right!
    @matrix = @matrix.each_with_object([]) do |row, result|
      row.each_with_index do |element, index|
        result[index] ||= []
        result[index].unshift(element)
      end
    end

    @borders = {
      @matrix.first => borders.values[3],
      @matrix.map(&:last) => borders.values[0],
      @matrix.last => borders.values[1],
      @matrix.map(&:first) => borders.values[2]
    }
  end

  def left_from(direction)
    {
      top: :left,
      right: :top,
      bottom: :right,
      left: :bottom
    }[direction]
  end

  def right_from(direction)
    {
      top: :right,
      right: :bottom,
      bottom: :left,
      left: :top
    }[direction]
  end

  def opposite(direction)
    {
      top: :bottom,
      right: :left,
      bottom: :top,
      left: :right
    }[direction]
  end

  def border_position(border)
    case border
    when borders.keys[0]
      :top
    when borders.keys[1]
      :right
    when borders.keys[2]
      :bottom
    when borders.keys[3]
      :left
    end
  end

  def find_border(border)
    borders.find do |k, v|
      v.nil? && (k == border || k == border.reverse)
    end
  end

  def borders
    @borders ||= {
      @matrix.first => nil,
      @matrix.map(&:last) => nil,
      @matrix.last => nil,
      @matrix.map(&:first) => nil
    }
  end

  def rows
    @matrix.map { |e| e.join("") }
  end

  def merged
    @matrix.map { |e| e.join("") }.join("\n")
  end

  def neighbors(tiles)
    borders.values.map { |id| tiles.find { |t| t.id == id } }
  end

  def to_id_array(tiles, x, y, result = [])
    return if result.flatten.include?(id)

    # print "#{id}@#{x}/#{y}\n"
    result[y] ||= []
    result[y][x] = id

    neighbors(tiles).each_with_index do |tile, index|
      next unless tile

      n_x = x + [0, 1, 0, -1][index]
      n_y = y + [-1, 0, 1, 0][index]
      tile.to_id_array(tiles, n_x, n_y, result)
    end

    result
  end

  def stripped_matrix
    @matrix[1..-2].map { |r| r[1..-2] }
  end

  def draw_all_monsters!
    4.times do
      draw_monsters!
      rotate_left!
    end

    flip_horizontally!

    4.times do
      draw_monsters!
      rotate_left!
    end

    merged
  end

  def draw_monsters!
    matrix.each_with_index do |row, index|
      offsets0 = row.join('').to_enum(:scan, SEA_MONSTER.keys[0]).map { Regexp.last_match.offset(0)[0] }

      next unless matrix[index + 1] && matrix[index + 2]

      offsets1 = matrix[index + 1].join('').to_enum(:scan, SEA_MONSTER.keys[1]).map { Regexp.last_match.offset(0)[0] }
      offsets2 = matrix[index + 2].join('').to_enum(:scan, SEA_MONSTER.keys[2]).map { Regexp.last_match.offset(0)[0] }

      offsets = offsets0 & offsets1 & offsets2

      offsets.each do |offset|
        draw_monster_line!(0, offset, matrix[index + 0])
        draw_monster_line!(1, offset, matrix[index + 1])
        draw_monster_line!(2, offset, matrix[index + 2])
      end
    end
  end

  def draw_monster_line!(line, offset_start, row)
    SEA_MONSTER.values[line].each do |offset|
      row[offset_start + offset] = '0'
    end
  end
end

tiles = File.read('input.txt').split("\n\n").map do |line|
  rows = line.split("\n")
  id = rows.shift.split(" ")[1].to_i

  Tile.new(id, rows.map(&:chars))
end

tiles.first.match_neighbors!(tiles)
top_left = tiles.find { |t| t.borders.values[0].nil? && t.borders.values[3].nil? }

big_tile = Tile.new(-1, top_left.to_id_array(tiles, 0, 0).flat_map do |row|
  matrix = row.each_with_object([]) do |id, result|
    tiles.find { |t| t.id == id }.stripped_matrix.each_with_index do |m_row, index|
      result[index] ||= []
      result[index] += m_row
    end

    result
  end

  matrix
end)

# pictures = []
# 4.times { pictures << big_tile.rows; big_tile.rotate_left! }

# big_tile.flip_vertically!
# 4.times { pictures << big_tile.rows; big_tile.rotate_left! }

# big_tile.flip_horizontally!
# 4.times { pictures << big_tile.rows; big_tile.rotate_left! }

# big_tile.flip_vertically!
# 4.times { pictures << big_tile.rows; big_tile.rotate_left! }

big_tile.rotate_left!
big_tile.flip_vertically!
print big_tile.draw_all_monsters!
print "\n"

p big_tile.merged.count("#") # 2146

