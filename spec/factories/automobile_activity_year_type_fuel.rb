require 'earth/automobile/automobile_activity_year_type_fuel'

FactoryGirl.define do
  factory :aaytf, :class => AutomobileActivityYearTypeFuel do
    trait(:gas_car_2009) { name '2009 cars gas'; activity_year 2009; type_name 'cars'; fuel_family 'gas' }
    trait(:gas_car_2010) { name '2010 cars gas'; activity_year 2010; type_name 'cars'; fuel_family 'gas' }
    trait(:diesel_car_2010) { name '2010 cars diesel'; activity_year 2010; type_name 'cars'; fuel_family 'diesel' }
  end
end
