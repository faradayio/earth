require 'earth/automobile/automobile_type_fuel_year'

FactoryGirl.define do
  factory :atfy, :class => AutomobileTypeFuelYear do
    trait(:cars_1984) { name 'cars gas 1984'; type_name 'cars'; fuel_family 'gas'; year 1984 }
    trait(:cars_2009) { name 'cars gas 2009'; type_name 'cars'; fuel_family 'gas'; year 2009 }
    trait(:cars_2011) { name 'cars gas 2011'; type_name 'cars'; fuel_family 'gas'; year 2011 }
  end
end
