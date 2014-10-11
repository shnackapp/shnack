categories ||= @categories

json.categories            categories do |c|
  json.name                c.name
  json.items               c.items do |i|
    json.name                i.name
    json.price               i.price
    json.description         i.description
    json.modifiers           i.modifiers do |m|
      json.mod_type             m.mod_type
      json.name                 m.name
      json.options              m.options do |o|
        json.name                 o.name
        json.price                o.price
      end
    end
  end
end
