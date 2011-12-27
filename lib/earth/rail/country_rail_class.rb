require 'earth/locality'
class CountryRailClass < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :country_iso_3166_code
  col :rail_class_name
  col :passengers, :type => :float
  col :speed, :type => :float
  col :speed_units
  col :trip_distance, :type => :float
  col :trip_distance_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :diesel_intensity, :type => :float
  col :diesel_intensity_units
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
end
