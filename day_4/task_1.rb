REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid) # cid
passports = File.read("input.txt").split("\n\n")

result = passports.select do |passport|
  passport = Hash[passport.split(/[\n ]/).map { |e| e.split(":") }]

  (REQUIRED_FIELDS - passport.keys).empty?
end.count

pp result
