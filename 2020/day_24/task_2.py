

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
  black_tile_ids = {}
  
  def __init__(self, x, y):
    self.x = x
    self.y = y
    self.color = "white"
    self.id = f"{x},{y}"
    self.neighbor_ids = set(f"{self.x + offset[0]},{self.y + offset[1]}" for offset in OFFSETS.values())
    
    Tile.all_tiles[self.id] = self
    Tile.counters[self.id] = 1
  
  def add_neighbor(self, direction):
    new_x = self.x + OFFSETS[direction][0]
    new_y = self.y + OFFSETS[direction][1]
    
    tile = Tile.find_or_initialize(new_x, new_y)
  
    return tile
  
  def flip(self):
    self.color = "white" if self.color == "black" else "black"
  
  def should_flip(self):
    black_neighbor_count = len(Tile.black_tile_ids & self.neighbor_ids)
    
    if self.color == "black":
      return (black_neighbor_count == 0 or black_neighbor_count > 2)
    else:
      return (black_neighbor_count == 2)
  
  @classmethod
  def find_or_initialize_by_id(self, id):
    x, y = id.split(",")
    
    return Tile.find_or_initialize(int(x), int(y))
    
  @classmethod
  def find_or_initialize(self, x, y):
    tile = Tile.all_tiles.get(f"{x},{y}")
    tile = tile or Tile(x, y)
    
    Tile.counters[tile.id] += 1
    
    return tile
    
  @classmethod
  def evolve(self):
    new_black_tile_ids = set()
    ids_to_flip = set()
    neighbor_ids = set()
    
    for tile_id in Tile.black_tile_ids:
      tile = Tile.find_or_initialize_by_id(tile_id)
      
      if tile.should_flip():
        ids_to_flip.add(tile_id) 
      else:
        new_black_tile_ids.add(tile_id)
      
      neighbor_ids.update(tile.neighbor_ids)
    
    for tile_id in (neighbor_ids - Tile.black_tile_ids):
      tile = Tile.find_or_initialize_by_id(tile_id)
      
      if tile.should_flip():
        ids_to_flip.add(tile_id) 
        new_black_tile_ids.add(tile_id)
    
    for tile_id in ids_to_flip:
      Tile.find_or_initialize_by_id(tile_id).flip()
    
    Tile.black_tile_ids = new_black_tile_ids

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
  
  current_tile.flip()

file.close()

Tile.black_tile_ids = set(id for (id, tile) in Tile.all_tiles.items() if tile.color == "black")

for _ in range(100):
  Tile.evolve()
  
print(len(Tile.black_tile_ids))
