require 'earth/automobile/automobile_activity_year_type_fuel'

FactoryGirl.define do
  factory :aaytf, :class => AutomobileActivityYearTypeFuel do
    trait(:gas_car_2009) { name '2009 Passenger cars gasoline'; activity_year 2009; type_name 'Passenger cars'; fuel_family 'gasoline' }
    trait(:gas_car_2010) { name '2010 Passenger cars gasoline'; activity_year 2010; type_name 'Passenger cars'; fuel_family 'gasoline' }
    trait(:diesel_car_2010) { name '2010 Passenger cars diesel'; activity_year 2010; type_name 'Passenger cars'; fuel_family 'gasoline' }
  end
end
