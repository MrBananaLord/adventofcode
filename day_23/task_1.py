cups = [3, 8, 9, 1, 2, 5, 4, 6, 7]
# cups = [1, 9, 8, 7, 5, 3, 4, 6, 2]
current_cup = cups[0]

for _ in range(100):
  next_cups = []

  # print(current_cup, cups)
  for x in range(3):
    current_cup_index = cups.index(current_cup)

    if (current_cup_index + 1 >= len(cups)):
      next_cups += [cups.pop(0)]
    else:
      next_cups += [cups.pop(current_cup_index + 1)]

  # print(next_cups)

  i = 1
  while (current_cup - i > 0) and ((current_cup - i) in next_cups):
    i += 1

  if (current_cup - i == 0):
    destination_index = cups.index(max(cups))
  else:
    destination_index = cups.index(current_cup - i)

  # print(cups[destination_index])

  cups = cups[0:destination_index + 1] + next_cups + cups[destination_index + 1:]

  if cups.index(current_cup) + 1 >= len(cups):
    current_cup = cups[0]
  else:
    current_cup = cups[cups.index(current_cup) + 1]

index = cups.index(1)
print((cups[index:] + cups[0:index])[1:])
