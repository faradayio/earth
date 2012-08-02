require 'earth/air/airport'

FactoryGirl.define do
  factory :airport, :class => Airport do
    trait(:lax) { iata_code 'LAX'; city 'Los Angeles' }
    trait(:mdw) { iata_code 'MDW'; city 'Chicago' }
    trait(:msn) { iata_code 'MSN'; city 'Madison' }
    trait(:ord) { iata_code 'ORD'; city 'Chicago' }
    trait(:sfo) { iata_code 'SFO'; city 'San Francisco' }
  end
end
