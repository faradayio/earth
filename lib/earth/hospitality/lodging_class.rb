require 'earth/locality'
class LodgingClass < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  
  # DEPRECATED - cut once new Lodging has been phased in
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :natural_gas_intensity, :type => :float
  col :natural_gas_intensity_units
  col :fuel_oil_intensity, :type => :float
  col :fuel_oil_intensity_units
  col :district_heat_intensity, :type => :float
  col :district_heat_intensity_units
end
