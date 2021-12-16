OFFSETS = {
  "e": [1,0],
  "se": [1,-1],
  "sw": [0,-1],
  "w": [-1,0],
  "nw": [-1,1],
  "ne": [0,1]
}

class Tile:
  all_tiles = {}
  counters  = {}
  
  def __init__(self, x, y):
    self.x = x
    self.y = y
    self.color = "white"
    self.id = f"[{x},{y}]"
    
    Tile.all_tiles[self.id] = self
    Tile.counters[self.id] = 1
  
  def add_neighbor(self, direction):
    new_x = self.x + OFFSETS[direction][0]
    new_y = self.y + OFFSETS[direction][1]
    
    tile = Tile.find_or_initialize(new_x, new_y)
  
    return tile
  
  def flip(self):
    self.color = "white" if self.color == "black" else "black"
  
  @classmethod
  def find_or_initialize(self, x, y):
    tile = Tile.all_tiles.get(f"[{x},{y}]")
    tile = tile or Tile(x, y)
    
    Tile.counters[tile.id] += 1
    
    return tile

file = open("input.txt", "r")

starting_tile = Tile(0,0)

for line in file.readlines():
  line = line.strip("\n")
  current_tile = starting_tile
  
  while (len(line) > 0):
    direction = line[0]
    
    if not (direction == "e" or direction == "w"):
      direction = line[0:2] 
      line = line[2:]
    else:
      line = line[1:]
    
    current_tile = current_tile.add_neighbor(direction)
  
  # print(f"position {current_tile.x},{current_tile.y}; {current_tile.color} color")
  current_tile.flip()
  # print(f"position {current_tile.x},{current_tile.y}; {current_tile.color} color")

file.close()

print(sum(tile.color == "black" for tile in list(Tile.all_tiles.values())))
print(Tile.counters.values())
