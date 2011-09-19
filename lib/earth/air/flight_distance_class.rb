class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  col :name
  col :distance, :type => :float
  col :distance_units
end