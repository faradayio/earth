class Country < ActiveRecord::Base
  set_primary_key :iso_3166_code
  
  falls_back_on :name => 'fallback',
                :automobile_urbanity => lambda { Country.united_states.automobile_urbanity }, # for now assume US represents world
                :automobile_fuel_efficiency => ((22.5 + 16.2) / 2.0).miles_per_gallon.to(:kilometres_per_litre), # average of passenger car fuel unknown and light goods vehicle fuel unknown - WRI Mobile Combustion calculation tool v2.0
                :automobile_fuel_efficiency_units => 'kilometres_per_litre',
                :automobile_city_speed => lambda { Country.united_states.automobile_city_speed }, # for now assume US represents world
                :automobile_city_speed_units => lambda { Country.united_states.automobile_city_speed_units }, # for now assume US represents world
                :automobile_highway_speed => lambda { Country.united_states.automobile_highway_speed }, # for now assume US represents world
                :automobile_highway_speed_units => lambda { Country.united_states.automobile_highway_speed_units }, # for now assume US represents world
                :automobile_trip_distance => lambda { Country.united_states.automobile_trip_distance }, # for now assume US represents world
                :automobile_trip_distance_units => lambda { Country.united_states.automobile_trip_distance_units }, # for now assume US represents world
                :flight_route_inefficiency_factor => lambda { Country.maximum(:flight_route_inefficiency_factor) } # default to the largest inefficiency factor
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
  end
  
  force_schema do
    string 'iso_3166_code'
    string 'name'
    float  'automobile_urbanity'
    float  'automobile_fuel_efficiency'
    string 'automobile_fuel_efficiency_units'
    float  'automobile_city_speed'
    string 'automobile_city_speed_units'
    float  'automobile_highway_speed'
    string 'automobile_highway_speed_units'
    float  'automobile_trip_distance'
    string 'automobile_trip_distance_units'
    float  'flight_route_inefficiency_factor'
  end
end
