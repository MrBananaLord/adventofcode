rules = File.read("input.txt").split("\n").map do |rule|
  parent, children = rule.split(" bags contain ")
  children = children.split(", ").filter_map do |child|
    next unless child.to_i.positive?

    [child.match(/\d (.*) bag/)[1], child.to_i]
  end

  [parent, Hash[children]]
end

rules = Hash[rules]

def count_children(rules, bag_name, bag_count)
  children = rules[bag_name]

  # p bag_count
  return bag_count unless children.any?

  children.reduce(0) { |sum, (name, count)| sum + count_children(rules, name, count) * bag_count } + bag_count
end

pp count_children(rules, "shiny gold", 1) - 1


