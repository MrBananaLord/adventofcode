import re
from pprint import pprint

class Lanternfish:
  collection = []
  
  def __init__(self, timer):
    self.timer = timer
    
    Lanternfish.collection.append(self)
    
  def age_1_day(self):
    if self.timer == 0:
      self.timer = 6
      Lanternfish(8)
    else:
      self.timer -= 1
    
file = open("input.txt", "r")
for line in file.readlines():
  states = list(map(lambda x: int(x), line.split(",")))
  
for state in states:
  Lanternfish(state)

for day in range(0,80):
  for fish in Lanternfish.collection[:]:
    fish.age_1_day()

print(len(Lanternfish.collection))
