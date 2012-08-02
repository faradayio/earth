require 'earth/automobile/automobile_type_fuel_year_control'

FactoryGirl.define do
  factory :atfyc, :class => AutomobileTypeFuelYearControl do
    trait(:car_1985_1) { name 'Passenger cars gasoline 1985 tier 1'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 1985 }
    trait(:car_2009_1) { name 'Passenger cars gasoline 2009 tier 1'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2009; type_fuel_control_name 'Passenger cars gasoline tier 1' }
    trait(:car_2009_2) { name 'Passenger cars gasoline 2009 tier 2'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2009; type_fuel_control_name 'Passenger cars gasoline tier 2' }
    trait(:car_2010_1) { name 'Passenger cars gasoline 2010 tier 1'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2010; type_fuel_control_name 'Passenger cars gasoline tier 1' }
    trait(:car_2010_2) { name 'Passenger cars gasoline 2010 tier 2'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2010; type_fuel_control_name 'Passenger cars gasoline tier 2' }
  end
end
