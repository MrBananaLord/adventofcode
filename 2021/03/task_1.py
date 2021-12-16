file = open("input.txt", "r")

lines = []

for line in file.readlines():
  digits = list(map(lambda x: int(x), list(line.strip("\n"))))
  
  lines.append(digits)

total = len(lines)
positive_bit_count = [sum(x) for x in zip(*lines)]
most_common_bits = list(map(lambda x: "1" if x > total / 2 else "0", positive_bit_count))

gamma_rate = int("".join(list(map(lambda x: "1" if x > total / 2 else "0", positive_bit_count))), 2)
epsilon_rate = int("".join(list(map(lambda x: "0" if x > total / 2 else "1", positive_bit_count))), 2)
  
print(gamma_rate * epsilon_rate)
