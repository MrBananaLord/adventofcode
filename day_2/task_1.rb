valid_passwords = File.read("input.txt").split("\n").filter_map do |entry|
  min, max, letter, _, password = entry.split(/[- :]/)

  next unless password.count(letter).between?(min.to_i, max.to_i)

  password
end

print valid_passwords.count
