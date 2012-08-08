require 'earth/rail/national_transit_database_record'

FactoryGirl.define do
  factory :ntd_record, :class => NationalTransitDatabaseRecord do
    trait(:sf_rail_record) { name 'SF muni rail'; company_id 'muni'; mode_code 'R'; vehicle_distance 10000; vehicle_time 100; passenger_distance 500000; passengers 5000; electricity 25000 }
    trait(:ny_rail_record) { name 'Metro north rail'; company_id 'mtn'; mode_code 'R' }
    trait(:bus_record) { name 'Golden gate transit bus'; company_id 'gg'; mode_code 'B' }
  end
end
