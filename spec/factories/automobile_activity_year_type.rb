require 'earth/automobile/automobile_activity_year_type'

FactoryGirl.define do
  factory :aayt, :class => AutomobileActivityYearType do
    trait(:car_2009) { name '2009 Passenger cars'; activity_year 2009; type_name 'Passenger cars' }
    trait(:car_2010) { name '2010 Passenger cars'; activity_year 2010; type_name 'Passenger cars' }
  end
end
