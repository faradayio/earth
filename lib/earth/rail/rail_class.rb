class RailClass < ActiveRecord::Base
  set_primary_key :name
  col :name
  col :description
  col :passengers, :type => :float
  col :distance, :type => :float
  col :distance_units
  col :speed, :type => :float
  col :speed_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :diesel_intensity, :type => :float
  col :diesel_intensity_units
end