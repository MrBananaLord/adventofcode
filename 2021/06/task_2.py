import re
from pprint import pprint

file = open("input.txt", "r")
fish = [0] * 9

for line in file.readlines():
  states = list(map(lambda x: int(x), line.split(",")))
  
for state in states:
  fish[state] += 1

for day in range(0,256):
  bday_fish_count = fish.pop(0)
  fish.append(bday_fish_count)
  fish[6] += bday_fish_count
  
print(sum(fish))
