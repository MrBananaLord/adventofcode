def transform(subject_number, loop_size):
  value = 1
  for _ in range(loop_size):
    value = (value * subject_number) % 20201227
  
  return value

def find_loop_size(subject_number, public_key):
  value = 1
  index = 0
  
  while (value != public_key):
    value = (value * subject_number) % 20201227
    index += 1  
  
  return index
    
# card_public_key = 5764801
# door_public_key = 17807724
card_public_key = 16915772
door_public_key = 18447943

card_loop_size = find_loop_size(7, card_public_key)
door_loop_size = find_loop_size(7, door_public_key)

transform(card_public_key, door_loop_size)


