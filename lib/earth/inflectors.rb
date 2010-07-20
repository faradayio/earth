ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable %w(aircraft aircraft Aircraft airline_aircraft AirlineAircraft)
  inflect.uncountable 'commons'
  inflect.uncountable 'food'
  inflect.uncountable 'shelter'
  inflect.uncountable 'transportation'
  inflect.uncountable 'press_coverage'
  inflect.irregular 'foot', 'feet'
end
