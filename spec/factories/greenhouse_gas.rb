require 'earth/fuel/greenhouse_gas'

FactoryGirl.define do
  factory :ghg, :class => GreenhouseGas do
    trait(:co2) { name 'Carbon dioxide'; abbreviation 'co2' }
  end
end
