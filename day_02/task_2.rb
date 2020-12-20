valid_passwords = File.read("input.txt").split("\n").filter_map do |entry|
  position_1, position_2, letter, _, password = entry.split(/[- :]/)

  letter_1 = password[position_1.to_i - 1]
  letter_2 = password[position_2.to_i - 1]

  next unless (letter_1 == letter || letter_2 == letter) && letter_1 != letter_2

  entry
end

pp valid_passwords.count
