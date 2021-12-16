require 'pry'

SEA_MONSTER = {
  /(?=(..................(#|O).))/ => [18],
  /(?=((#|O)....(#|O)(#|O)....(#|O)(#|O)....(#|O)(#|O)(#|O)))/ => [0, 5, 6, 11, 12, 17, 18, 19],
  /(?=(.(#|O)..(#|O)..(#|O)..(#|O)..(#|O)..(#|O)...))/ => [1, 4, 7, 10, 13, 16]
}.freeze

class Tile
  attr_reader :id, :matrix, :borders

  def initialize(id, matrix)
    @id = id
    @matrix = matrix

    update_neighbors!(nil, nil, nil, nil)
  end

  def self.tiles
    @tiles ||= []
  end

  def tiles
    self.class.tiles
  end

  def match_neighbors!
    return if @matched

    @matched = true

    borders.each do |border, neighbor|
      next if neighbor
      next unless (new_neighbor = find_other_by_border(border))

      fit_neighbor!(new_neighbor, border)

      new_neighbor.match_neighbors!
    end
  end

  def find_other_by_border(border)
    tiles.find do |tile|
      next if tile == self

      tile.border?(border) || tile.border?(border.reverse)
    end
  end

  def fit_neighbor!(other, border)
    borders[border] = other.id
    other.border?(border) ? other.borders[border] = id : other.borders[border.reverse] = id

    other.match_border!(border, opposite(border_position(border)))

    other
  end

  def border?(border)
    borders.key?(border)
  end

  def match_border!(border, side)
    4.times do
      return if side == border_position(border)

      rotate_left!
    end

    flip_horizontally!

    4.times do
      return if side == border_position(border)

      rotate_left!
    end
  end

  def properly_positioned?
    borders.map do |border, id|
      next true if id.nil?

      neighbor = tiles.find { |n| n.id == id }

      next :reversed unless neighbor.border?(border)
      next :malpositioned unless border_position(border) == opposite(neighbor.border_position(border))

      true
    end
  end

  def flip_horizontally!
    @matrix = @matrix.map(&:reverse)

    update_neighbors!(neighbor_ids[0], neighbor_ids[3], neighbor_ids[2], neighbor_ids[1])
  end

  def rotate_left!
    @matrix = @matrix.map(&:reverse).transpose

    update_neighbors!(neighbor_ids[1], neighbor_ids[2], neighbor_ids[3], neighbor_ids[0])
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

  def update_neighbors!(top, right, bottom, left)
    @borders = {
      @matrix.first => top,
      @matrix.map(&:last) => right,
      @matrix.last => bottom,
      @matrix.map(&:first) => left
    }
  end

  def merged
    @matrix.map { |e| e.join('') }.join("\n")
  end

  def neighbors
    borders.values.map { |id| tiles.find { |t| t.id == id } }
  end

  def neighbor_ids
    borders.values
  end

  def to_id_array(x = 0, y = 0, result = [])
    return if result.flatten.include?(id)

    result[y] ||= []
    result[y][x] = id

    neighbors.each_with_index do |tile, index|
      next unless tile

      new_x = x + [0, 1, 0, -1][index]
      new_y = y + [-1, 0, 1, 0][index]
      tile.to_id_array(new_x, new_y, result)
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
    matrix.length.times do |index|
      next unless matrix[index + 1] && matrix[index + 2]

      monster_offsets(index).each do |offset|
        draw_monster!(index, offset)
      end
    end
  end

  def monster_offsets(index)
    [
      monster_offsets_for_row(matrix[index + 0], 0),
      monster_offsets_for_row(matrix[index + 1], 1),
      monster_offsets_for_row(matrix[index + 2], 2)
    ].reduce(&:&)
  end

  def monster_offsets_for_row(row, line)
    row.join('').to_enum(:scan, SEA_MONSTER.keys[line]).map { Regexp.last_match.offset(0)[0] }
  end

  def draw_monster!(index, offset)
    draw_monster_line!(0, offset, matrix[index + 0])
    draw_monster_line!(1, offset, matrix[index + 1])
    draw_monster_line!(2, offset, matrix[index + 2])
  end

  def draw_monster_line!(line, offset_start, row)
    SEA_MONSTER.values[line].each do |offset|
      row[offset_start + offset] = 'O'
    end
  end
end

tiles = File.read('input.txt').split("\n\n").map do |line|
  rows = line.split("\n")
  id = rows.shift.split(' ')[1].to_i

  tile = Tile.new(id, rows.map(&:chars))
  Tile.tiles << tile
  tile
end

tiles.first.match_neighbors!
top_left = tiles.find { |t| t.borders.values[0].nil? && t.borders.values[3].nil? }

big_tile = Tile.new(0, top_left.to_id_array.flat_map do |row|
  matrix = row.each_with_object([]) do |id, result|
    tiles.find { |t| t.id == id }.stripped_matrix.each_with_index do |m_row, index|
      result[index] ||= []
      result[index] += m_row
    end

    result
  end

  matrix
end)

big_tile.rotate_left!
big_tile.flip_horizontally!
print big_tile.draw_all_monsters!.gsub('O', "\e[35mO\e[0m").gsub('#', "\e[36mO\e[0m").gsub('.', "\e[34mO\e[0m")
print "\n"

p big_tile.merged.count("#") # 2146
