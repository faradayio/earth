LodgingClass.class_eval do
  schema Earth.database_options do
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
  
  data_miner do
    
  end
end
