require 'earth/automobile/automobile_type_fuel_year_control'

FactoryGirl.define do
  factory :atfyc, :class => AutomobileTypeFuelYearControl do
    trait(:cars_1985_1) { name 'cars gas 1985 tier 1'; type_name 'cars'; fuel_family 'gas'; year 1985; type_fuel_control_name 'cars gas tier 1' }
    trait(:cars_2009_1) { name 'cars gas 2009 tier 1'; type_name 'cars'; fuel_family 'gas'; year 2009; type_fuel_control_name 'cars gas tier 1' }
    trait(:cars_2009_2) { name 'cars gas 2009 tier 2'; type_name 'cars'; fuel_family 'gas'; year 2009; type_fuel_control_name 'cars gas tier 2' }
    trait(:cars_2010_1) { name 'cars gas 2010 tier 1'; type_name 'cars'; fuel_family 'gas'; year 2010; type_fuel_control_name 'cars gas tier 1' }
    trait(:cars_2010_2) { name 'cars gas 2010 tier 2'; type_name 'cars'; fuel_family 'gas'; year 2010; type_fuel_control_name 'cars gas tier 2' }
  end
end
