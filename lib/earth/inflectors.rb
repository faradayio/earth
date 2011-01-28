ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable 'aircraft'
  inflect.uncountable 'commons'
  inflect.uncountable 'food'
  inflect.uncountable 'shelter'
  inflect.uncountable 'transportation'
  inflect.uncountable 'species'
  inflect.irregular 'foot', 'feet'
  inflect.plural /(gas)\z/i, '\1es'
  inflect.singular /(gas)es\z/i, '\1'
end
