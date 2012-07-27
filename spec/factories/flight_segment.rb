require 'factory_girl'
require 'earth/air/flight_segment'

FactoryGirl.define do
  factory :flight_segment, :class => FlightSegment do
    row_hash { "fake-#{rand(1e11)}" }
    
    trait(:from_lax) { origin_airport_iata_code 'LAX' }
    trait(:from_ord) { origin_airport_iata_code 'ORD' }
    
    trait(:from_los_angeles) { origin_airport_city 'Los Angeles' }
    trait(:from_chicago) { origin_airport_city 'Chicago' }
    
    trait(:to_sfo) { destination_airport_iata_code 'SFO' }
    trait(:to_msn) { destination_airport_iata_code 'MSN' }
    trait(:to_lax) { destination_airport_iata_code 'LAX' }
    trait(:to_ord) { destination_airport_iata_code 'ORD' }
    
    trait(:to_los_angeles) { destination_airport_city 'Los Angeles' }
    trait(:to_chicago) { destination_airport_city 'Chicago' }
    
    trait(:june_2010) { month 6; year 2010 }
    trait(:may_2011) { year 2011; month 5 }
    trait(:june_2011) { year 2011; month 6 }
    trait(:may_25_2011) { year 2011; month 5 }
    trait(:july_2011) { year 2011; month 7 }
    
    trait(:united) { airline_bts_code 'UA' }
    trait(:delta) { airline_bts_code 'DL' }
    trait(:lufthansa) { airline_bts_code 'LH' }
    trait(:united_icao) { airline_icao_code 'UAL' }
    trait(:delta_icao) { airline_icao_code 'DAL' }
    trait(:lufthansa_icao) { airline_icao_code 'DLH' }
    
    trait(:loaded) { load_factor 0.99 }
    trait(:empty) { load_factor 0.01 }
  end
end
