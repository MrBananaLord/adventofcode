OFFSETS =[
  [0, 0, 0, 1],
  [0, 0, 0, -1],
  [0, 0, 1, 0],
  [0, 0, 1, 1],
  [0, 0, 1, -1],
  [0, 0, -1, 0],
  [0, 0, -1, 1],
  [0, 0, -1, -1],
  [0, 1, 0, 0],
  [0, 1, 0, 1],
  [0, 1, 0, -1],
  [0, 1, 1, 0],
  [0, 1, 1, 1],
  [0, 1, 1, -1],
  [0, 1, -1, 0],
  [0, 1, -1, 1],
  [0, 1, -1, -1],
  [0, -1, 0, 0],
  [0, -1, 0, 1],
  [0, -1, 0, -1],
  [0, -1, 1, 0],
  [0, -1, 1, 1],
  [0, -1, 1, -1],
  [0, -1, -1, 0],
  [0, -1, -1, 1],
  [0, -1, -1, -1],
  [1, 0, 0, 0],
  [1, 0, 0, 1],
  [1, 0, 0, -1],
  [1, 0, 1, 0],
  [1, 0, 1, 1],
  [1, 0, 1, -1],
  [1, 0, -1, 0],
  [1, 0, -1, 1],
  [1, 0, -1, -1],
  [1, 1, 0, 0],
  [1, 1, 0, 1],
  [1, 1, 0, -1],
  [1, 1, 1, 0],
  [1, 1, 1, 1],
  [1, 1, 1, -1],
  [1, 1, -1, 0],
  [1, 1, -1, 1],
  [1, 1, -1, -1],
  [1, -1, 0, 0],
  [1, -1, 0, 1],
  [1, -1, 0, -1],
  [1, -1, 1, 0],
  [1, -1, 1, 1],
  [1, -1, 1, -1],
  [1, -1, -1, 0],
  [1, -1, -1, 1],
  [1, -1, -1, -1],
  [-1, 0, 0, 0],
  [-1, 0, 0, 1],
  [-1, 0, 0, -1],
  [-1, 0, 1, 0],
  [-1, 0, 1, 1],
  [-1, 0, 1, -1],
  [-1, 0, -1, 0],
  [-1, 0, -1, 1],
  [-1, 0, -1, -1],
  [-1, 1, 0, 0],
  [-1, 1, 0, 1],
  [-1, 1, 0, -1],
  [-1, 1, 1, 0],
  [-1, 1, 1, 1],
  [-1, 1, 1, -1],
  [-1, 1, -1, 0],
  [-1, 1, -1, 1],
  [-1, 1, -1, -1],
  [-1, -1, 0, 0],
  [-1, -1, 0, 1],
  [-1, -1, 0, -1],
  [-1, -1, 1, 0],
  [-1, -1, 1, 1],
  [-1, -1, 1, -1],
  [-1, -1, -1, 0],
  [-1, -1, -1, 1],
  [-1, -1, -1, -1]
]

require 'pry'

class Cube
  attr_reader :x, :y, :z, :w, :state, :next_state

  def initialize(x, y, z, w, state = ".")
    @x = x
    @y = y
    @z = z
    @w = w
    @state = state
    @next_state = state
  end

  def self.find_or_new(x, y, z, w)
    active.find { |cube| cube.at_position?(x, y, z, w) } ||
    candidates.find { |cube| cube.at_position?(x, y, z, w) } ||
    cube = Cube.new(x, y, z, w)
  end

  def self.candidates
    @candidates ||= []
  end

  def self.candidates=(val)
    @candidates = val
  end

  def self.active
    @active ||= []
  end

  def self.active=(val)
    @active = val
  end

  def self.range(axis)
    min = active.min { |a, b| a.public_send(axis) <=> b.public_send(axis) }.public_send(axis)
    max = active.max { |a, b| a.public_send(axis) <=> b.public_send(axis) }.public_send(axis)

    (min..max)
  end

  def id
    "#{x},#{y},#{z},#{w}"
  end

  def neighbors
    OFFSETS.map do |offset|
      self.class.find_or_new(x + offset[0], y + offset[1], z + offset[2], w + offset[3])
    end
  end

  def active_neighbors
    OFFSETS.filter_map do |offset|
      self.class.active.find { |cube| cube.at_position?(x + offset[0], y + offset[1], z + offset[2], w + offset[3]) }
    end
  end

  def active?
    @state == "#"
  end

  def inactive?
    @state == "."
  end

  def calculate_next_state
    @next_state = if active?
      self.class.candidates = (neighbors.select(&:inactive?) + self.class.candidates).uniq { |e| e.id }

      active_neighbors.count(&:active?).between?(2,3) ? "#" : "."
    else
      active_neighbors.count(&:active?) == 3 ? "#" : "."
    end
  end

  def at_position?(x, y, z, w)
    @x == x && @y == y && @z == z && @w == w
  end

  def evolve!
    @state = @next_state
  end
end

Cube.active = []
Cube.candidates = []

File.read("test_input.txt").split("\n").each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    Cube.active << Cube.new(x, y, 0, 0, "#") if char == "#"
  end
end

def print_map
  Cube.range(:w).each do |w|
    Cube.range(:z).each do |z|
      print_layer(z, w)
    end
  end
end

def print_layer(z, w)
  print "\nz=#{z}, w=#{w}\n"

  Cube.range(:y).each do |y|
    Cube.range(:x).each do |x|
      # print x, y, z`
      print Cube.find_or_new(x, y, z, w).state
    end

    print "\n"
  end
end

# print_map

6.times.each do |i|
  print "cycle #{i + 1}\n"
  print "active cubes count == #{Cube.active.count}\n"

  Cube.candidates = []
  Cube.active.each { |c| c.calculate_next_state }

  print "candidates count == #{Cube.candidates.count}\n"
  Cube.candidates.each { |c| c.calculate_next_state }

  Cube.active = (Cube.active + Cube.candidates).select do |cube|
    cube.evolve!
    cube.active?
  end

  # print_map
end

p Cube.active.count
