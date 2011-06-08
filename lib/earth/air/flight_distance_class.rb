class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  create_table do
    string 'name'
    float  'distance'
    string 'distance_units'
  end
end
