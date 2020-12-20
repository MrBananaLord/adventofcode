rules = File.read("input.txt").split("\n").map do |rule|
  parent, children = rule.split(" bags contain ")
  children = children.split(", ").filter_map do |child|
    next unless child.to_i.positive?

    [child.match(/\d (.*) bag/)[1], child.to_i]
  end

  [parent, Hash[children]]
end

rules = Hash[rules]

def possible_roots_for(rules, bag_name)
  rules.filter_map do |name, children|
    next unless children[bag_name]

    possible_roots_for(rules, name) << name
  end.flatten.uniq
end

p possible_roots_for(rules, "shiny gold").count

