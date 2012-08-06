require 'earth/automobile/automobile_type_fuel'

FactoryGirl.define do
  factory :atf, :class => AutomobileTypeFuel do
    trait(:car_gas) { name 'cars gas'; type_name 'cars'; fuel_family 'gas' }
  end
end
