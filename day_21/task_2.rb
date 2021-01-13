require 'pry'

allergens = {}

foods = File.read('input.txt').split("\n").each_with_index.map do |line, index|
  line.delete!(")")

  food_ingredients, food_allergens = line.split(' (contains ')

  food_ingredients = food_ingredients.split(' ')
  food_allergens = food_allergens.split(', ')

  food_allergens.each do |allergen|
    if allergens.key?(allergen)
      allergens[allergen] = allergens[allergen] & food_ingredients
    else
      allergens[allergen] = food_ingredients
    end
  end

  {
    id: index + 1,
    ingredients: food_ingredients,
    allergens: food_allergens
  }
end

identified_ingredients = allergens.values.select { |v| v.count == 1 }.flatten.uniq

while allergens.values.any? { |v| v.count > 1 }
  allergens.each do |allergen, candidates|
    next if candidates.count < 2

    allergens[allergen] = candidates - identified_ingredients
    identified_ingredients += allergens[allergen] if allergens[allergen].count == 1
  end
end

p Hash[allergens.sort].values.flatten.join(',')
