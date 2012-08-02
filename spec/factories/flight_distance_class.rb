require 'earth/air/flight_distance_class'

FactoryGirl.define do
  factory :flight_distance_class, :class => FlightDistanceClass do
    trait(:short) { name 'short'; distance 1000; min_distance 0; max_distance 3500 }
    trait(:long) { name 'long'; distance 6000; min_distance 3500; max_distance 20037.6 }
  end
end
