class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  col :name
  col :distance, :type => :float
  col :distance_units
  col :min_distance, :type => :float
  col :min_distance_units
  col :max_distance, :type => :float
  col :max_distance_units
  col :passengers, :type => :float
end