OFFSETS = [
  [0, 0, -1],
  [0, 0, 1],
  [0, -1, 0],
  [0, -1, -1],
  [0, -1, 1],
  [0, 1, 0],
  [0, 1, -1],
  [0, 1, 1],
  [-1, 0, 0],
  [-1, 0, -1],
  [-1, 0, 1],
  [-1, -1, 0],
  [-1, -1, -1],
  [-1, -1, 1],
  [-1, 1, 0],
  [-1, 1, -1],
  [-1, 1, 1],
  [1, 0, 0],
  [1, 0, -1],
  [1, 0, 1],
  [1, -1, 0],
  [1, -1, -1],
  [1, -1, 1],
  [1, 1, 0],
  [1, 1, -1],
  [1, 1, 1]
]

require 'pry'

class Cube
  attr_reader :x, :y, :z, :state, :next_state

  def initialize(x, y, z, state = ".")
    @x = x
    @y = y
    @z = z
    @state = state
    @next_state = state
  end

  def self.find_or_new(x, y, z)
    active.find { |cube| cube.at_position?(x, y, z) } ||
    candidates.find { |cube| cube.at_position?(x, y, z) } ||
    cube = Cube.new(x, y, z)
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
    "#{x},#{y},#{z}"
  end

  def neighbors
    OFFSETS.map do |offset|
      self.class.find_or_new(x + offset[0], y + offset[1], z + offset[2])
    end
  end

  def active?
    @state == "#"
  end

  def inactive?
    @state == "."
  end

  def calculate_next_state
    cubes = neighbors

    @next_state = if active?
      self.class.candidates = (cubes.select(&:inactive?) + self.class.candidates).uniq { |e| e.id }
      cubes.count(&:active?).between?(2,3) ? "#" : "."
    else
      cubes.count(&:active?) == 3 ? "#" : "."
    end
  end

  def at_position?(x, y, z)
    @x == x && @y == y && @z == z
  end

  def evolve!
    @state = @next_state
  end
end

Cube.active = []
Cube.candidates = []

File.read("input.txt").split("\n").each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    Cube.active << Cube.new(x, y, 0, "#") if char == "#"
  end
end

def print_map
  Cube.range(:z).each do |z|
    print_layer(z)
  end
end

def print_layer(z)
  print "\nz=#{z}\n"

  Cube.range(:y).each do |y|
    Cube.range(:x).each do |x|
      # print x, y, z`
      print Cube.find_or_new(x, y, z).state
    end

    print "\n"
  end
end

print_map

6.times.each do
  Cube.candidates = []
  Cube.active.each { |c| c.calculate_next_state }
  Cube.candidates.each { |c| c.calculate_next_state }
  Cube.active = (Cube.active + Cube.candidates).select do |cube|
    cube.evolve!
    cube.active?
  end
end

p Cube.active.count
