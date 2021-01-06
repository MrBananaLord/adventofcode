require 'pry'

class Tile
  attr_reader :unmatched_borders, :id, :matrix

  def initialize(id, matrix)
    @id = id
    @matrix = matrix
  end

  def positioned?
    !!@positioned
  end

  def position!(tiles)
    borders.each do |border, neighbor|
      next if neighbor

      tiles.find do |tile|
        match_tiles!(tile, border)
      end
    end

    borders
  end

  def match_tiles!(other, border)
    return if other == self || positioned? || other.positioned?

    if other.find_border(border)
      borders[border] = other.id
      other.borders[border] = id
      other
    elsif other.find_border(border.reverse)
      borders[border] = other.id
      other.borders[border.reverse] = id
      other
    end
  end

  def find_border(border)
    borders.find do |k, v|
      v.nil? && k == border
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
end

tiles = File.read('test_input.txt').split("\n\n").map do |line|
  rows = line.split("\n")
  id = rows.shift.split(" ")[1].to_i

  Tile.new(id, rows.map(&:chars))
end

tiles.each do |t|
  t.position!(tiles)
end

corners = tiles.filter_map { |t| t.borders.count { |_, v| v.nil? } == 2 ? t.id : next }

p corners
p corners.reduce(:*)
