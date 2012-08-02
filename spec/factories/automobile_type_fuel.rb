require 'earth/automobile/automobile_type_fuel'

FactoryGirl.define do
  factory :atf, :class => AutomobileTypeFuel do
    trait(:car_gas) { name 'Passenger cars gasoline'; type_name 'Passenger cars'; fuel_family 'gasoline' }
  end
end
