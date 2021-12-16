REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid) # cid
VALID_EYE_COLORS = %w(amb blu brn gry grn hzl oth)

passports = File.read("input.txt").split("\n\n")

def valid_height?(height)
  if height.end_with?("cm")
    return height.to_i.between?(150, 193)
  elsif height.end_with?("in")
    return height.to_i.between?(59, 76)
  end

  false
end

def valid_passport?(passport)
  return false unless (REQUIRED_FIELDS - passport.keys).empty?
  return false unless passport["byr"].to_i.between?(1920, 2002)
  return false unless passport["iyr"].to_i.between?(2010, 2020)
  return false unless passport["eyr"].to_i.between?(2020, 2030)
  return false unless valid_height?(passport["hgt"])
  return false unless passport["hcl"].match?(/^#[0-9a-f]{6}$/)
  return false unless VALID_EYE_COLORS.include?(passport["ecl"])
  return false unless passport["pid"].match?(/^[0-9]{9}$/)

  true
end

result = passports.select do |passport|
  passport = Hash[passport.split(/[\n ]/).map { |e| e.split(":") }]

  valid_passport?(passport)
end.count

pp result
