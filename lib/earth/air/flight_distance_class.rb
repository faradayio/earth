class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  force_schema do
    string 'name'
    float  'distance'
    string 'distance_units'
  end
end
