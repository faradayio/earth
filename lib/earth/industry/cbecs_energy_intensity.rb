require 'earth/locality'

class CbecsEnergyIntensity < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :naics_code
  col :census_division_number, :type => :integer
  col :electricity, :type => :float
  col :electricity_units
  col :floorspace, :type => :float
  col :floorspace_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
end
