require 'earth/air/airline'

FactoryGirl.define do
  factory :airline, :class => Airline do
    trait(:delta) { iata_code 'DL'; name 'Delta'; icao_code 'DAL'; bts_code 'DL' }
    trait(:united) { iata_code 'UA'; name 'United'; icao_code 'UAL'; bts_code 'UL' }
    trait(:lufthansa) { iata_code 'LH'; name 'Lufthansa'; icao_code 'DLH'; bts_code 'LH' }
  end
end
