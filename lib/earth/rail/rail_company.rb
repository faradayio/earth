class RailCompany < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code'
  
  col :name
  col :country_iso_3166_code
  col :duns_number
  col :passengers, :type => :float
  col :passenger_distance, :type => :float
  col :passenger_distance_units
  col :train_distance, :type => :float
  col :train_distance_units
  col :train_time, :type => :float
  col :train_time_units
  col :trip_distance, :type => :float
  col :trip_distance_units
  col :speed, :type => :float
  col :speed_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :diesel_intensity, :type => :float
  col :diesel_intensity_units
  col :emission_factor, :type => :float
  col :emission_factor_units
end
