file = open("input.txt", "r")

previous_depth = None
increased_depth_counter = 0

for line in file.readlines():
  depth = int(line.strip("\n"))
  
  if previous_depth != None and depth > previous_depth:
    increased_depth_counter += 1 
    
  previous_depth = depth
  
print(increased_depth_counter)
