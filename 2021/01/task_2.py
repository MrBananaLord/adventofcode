file = open("input.txt", "r")

queue = []
increased_depth_counter = 0

for line in file.readlines():
  previous_depth = None
  
  if len(queue) == 3:
    previous_depth = sum(queue)
    queue.pop(0)
    
  queue.append(int(line.strip("\n")))
  
  if previous_depth != None and sum(queue) > previous_depth:
    increased_depth_counter += 1 
    
print(increased_depth_counter)
