require 'earth/air/airport'

FactoryGirl.define do
  factory :airport, :class => Airport do
    trait(:airport1) { iata_code 'test1'; latitude 0; longitude 0 }
    trait(:airport2) { iata_code 'test2'; latitude 0; longitude 1 }
  end
end
