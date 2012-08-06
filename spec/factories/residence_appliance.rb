require 'earth/residence/residence_appliance'

FactoryGirl.define do
  factory :residence_appliance, :class => ResidenceAppliance do
    trait(:fridge) { name 'fridge'; annual_energy_from_electricity 1000 }
  end
end
