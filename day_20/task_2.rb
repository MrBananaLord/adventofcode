require 'pry'

class Tile
  attr_reader :unmatched_borders, :id, :matrix

  def initialize(id, matrix)
    @id = id
    @matrix = matrix
  end

  def find_neighbors!(tiles)
    borders.each do |border, neighbor|
      next if neighbor

      new_neighbor = tiles.find do |tile|
        next if tile == self

        tile.find_border(border)
      end

      update_border!(new_neighbor, border) if new_neighbor
    end

    borders
  end

  def fit_neighbors!(tiles)
    borders.each do |border, neighbor|
      next unless neighbor

      tiles.find { |t| t.id == neighbor }.fit_border!(border, opposite(border_position(border)))
    end
  end

  def fit_border!(border, side)
    unless borders.key?(border)
      flip_horizontally!

      unless borders.key?(border)
        flip_horizontally!
        flip_vertically!
      end
    end

    return if side == border_position(border)

    if side == opposite(border_position(border))
      %i[top bottom].include?(side) ? flip_vertically! : flip_horizontally!
    else
      rotate_left! until side == border_position(border)
    end
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

  def update_border!(other, border)
    borders[border] = other.id
    other.borders.key?(border) ? other.borders[border] = id : other.borders[border.reverse] = id

    other
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

  def merged
    @matrix.map { |e| e.join("") }.join("\n")
  end

  def neighbors(tiles)
    borders.values.map { |id| tiles.find { |t| t.id == id } }
  end

  def to_id_array(tiles, x, y, result = [])
    return if result.flatten.include?(id)

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
end

tiles = File.read('test_input.txt').split("\n\n").map do |line|
  rows = line.split("\n")
  id = rows.shift.split(" ")[1].to_i

  Tile.new(id, rows.map(&:chars))
end

tiles.each { |t| t.find_neighbors!(tiles) }
tiles.each { |t| t.fit_neighbors!(tiles) }

corners = tiles.filter_map { |t| t.borders.count { |_, v| v.nil? } == 2 ? t.id : next }
first = tiles.find { |t| t.id == corners.first }

side_length = (tiles.count**1 / 3)

big_tile = Tile.new(-1, first.to_id_array(tiles, 0, side_length - 1).map do |row|
  matrix = row.each_with_object([]) do |id, result|
    tiles.find { |t| t.id == id }.stripped_matrix.each_with_index do |m_row, index|
      result[index] ||= []
      result[index] += m_row
    end

    result
  end

  matrix
end.flatten(1))

big_tile.flip_vertically!
print big_tile.merged
