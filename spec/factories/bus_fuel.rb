require 'earth/bus/bus_fuel'

FactoryGirl.define do
  factory :bus_fuel, :class => BusFuel do
    trait(:gas) { name 'gas' }
  end
end
