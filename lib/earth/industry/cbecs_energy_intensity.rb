require 'earth/locality'
class CbecsEnergyIntensity < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :naics_code
  col :census_division_number, :type => :integer
  col :total_electricity_consumption, :type => :float
  col :total_floorspace, :type => :float
  col :electricity_intensity, :type => :float
end
