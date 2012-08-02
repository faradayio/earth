require 'earth/automobile/automobile_type_fuel_year'

FactoryGirl.define do
  factory :atfy, :class => AutomobileTypeFuelYear do
    trait(:car_1984) { name 'Passenger cars gasoline 1984'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 1984 }
    trait(:car_2009) { name 'Passenger cars gasoline 2009'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2009 }
    trait(:car_2011) { name 'Passenger cars gasoline 2011'; type_name 'Passenger cars'; fuel_family 'gasoline'; year 2011 }
  end
end
