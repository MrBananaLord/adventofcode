file = open("input.txt", "r")

lines = []

for line in file.readlines():
  digits = list(map(lambda x: int(x), list(line.strip("\n"))))
  
  lines.append(digits)

def positive_bit_count(collection):
  return [sum(x) for x in zip(*collection)]
  
def most_common_bits(collection):
  return list(map(lambda x: 1 if x >= len(collection) / 2 else 0, positive_bit_count(collection)))
  
def least_common_bits(collection):
  return list(map(lambda x: 0 if x >= len(collection) / 2 else 1, positive_bit_count(collection)))
    
def find_rating(collection, bit_criteria_function):
  filtered_ratings = collection
  position = 0
  
  while len(filtered_ratings) > 1:
    filtered_ratings = list(filter(lambda x: x[position] == bit_criteria_function(filtered_ratings)[position], filtered_ratings))
    position += 1
    
  return filtered_ratings[0]


oxygen_generator_rating = int("".join(map(lambda x: str(x), find_rating(lines, most_common_bits))), 2)
co2_scrubber_rating = int("".join(map(lambda x: str(x), find_rating(lines, least_common_bits))), 2)

print(oxygen_generator_rating * co2_scrubber_rating)
