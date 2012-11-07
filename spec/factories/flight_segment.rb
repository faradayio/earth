require 'earth/air/flight_segment'

FactoryGirl.define do
  factory :flight_segment, :class => FlightSegment do
    row_hash { "fake-#{rand(1e11)}" }
    trait(:delta) { airline_bts_code 'DL' }
    trait(:delta_icao) { airline_icao_code 'DAL' }
  end
end
