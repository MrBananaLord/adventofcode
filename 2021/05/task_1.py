import re
from pprint import pprint
import numpy as np

file = open("input.txt", "r")
coordinates = []

max_x = 0
max_y = 0

for line in file.readlines():
  digits = list(map(lambda x: int(x), re.findall(r'\d+', line)))
  
  max_x = max(max_x, digits[0], digits[2])
  max_y = max(max_x, digits[1], digits[3])
  
  coordinates.append([(digits[0], digits[1]), (digits[2], digits[3])])

diagram = np.zeros((max_x + 1, max_y + 1), dtype=np.int8)

for line in coordinates:
  if line[0][0] == line[1][0] or line[0][1] == line[1][1]:
    for y in range(min(line[0][1], line[1][1]), max(line[0][1], line[1][1]) + 1):
      for x in range(min(line[0][0], line[1][0]), max(line[0][0], line[1][0]) + 1):
        diagram[y][x] += 1
        
pprint(np.count_nonzero(diagram > 1))
