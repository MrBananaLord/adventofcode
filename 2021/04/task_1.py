file = open("input.txt", "r")

class Board:
  def __init__(self):
    self.rows = []
    self.numbers = []
    self.marks = []
  
  def add_row(self, row):
    self.rows.append(row)
    self.numbers.extend(row)
    self.marks.append([0] * len(row))
    
  def mark_number(self, number):
    if number in self.numbers:
      row_index = int(self.numbers.index(number) // self.row_count())
      column_index = self.numbers.index(number) % self.column_count()
      self.marks[row_index][column_index] = 1
      
  def column_count(self):
    return len(self.rows[0])
  
  def row_count(self):
    return len(self.rows)
      
  def is_winner(self):
    if self.column_count() in [sum(x) for x in self.marks] or self.row_count() in [sum(x) for x in zip(*self.marks)]:
      return True
      
    return False
  
  def score(self):
    result = 0
    flat_marks = [item for sublist in self.marks for item in sublist]
    for index, mark in enumerate(flat_marks):
      if mark == 0:
        result += self.numbers[index]
    return result
    
numbers = list(map(lambda x: int(x), file.readline().split(",")))
boards = []
board = None

for line in file.readlines():
  line = line.strip("\n")
  
  if len(line) == 0:
    board = Board()
    boards.append(board)
  else:
    row = list(map(lambda x: int(x), line.split()))
    board.add_row(row)

last_number = None
winner = None
for number in numbers:
  last_number = number
  for board in boards:
    board.mark_number(number)
    if board.is_winner():
      winner = board
      break
    
  if winner:
    break

print(winner.score() * number)
