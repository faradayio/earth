require 'earth/locality'
class CountryLodgingClass < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :country_iso_3166_code
  col :lodging_class_name
  col :cbecs_detailed_activity
  col :natural_gas_intensity, :type => :float
  col :natural_gas_intensity_units
  col :fuel_oil_intensity, :type => :float
  col :fuel_oil_intensity_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :steam_intensity, :type => :float
  col :steam_intensity_units
  col :weighting, :type => :float
end
