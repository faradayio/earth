require 'earth/automobile/automobile_activity_year_type'

FactoryGirl.define do
  factory :aayt, :class => AutomobileActivityYearType do
    trait(:cars_2009) { name '2009 cars'; activity_year 2009; type_name 'cars' }
    trait(:cars_2010) { name '2010 cars'; activity_year 2010; type_name 'cars' }
  end
end
