require 'earth/locality'
class CbecsEnergyIntensity < ActiveRecord::Base
  col :naics_code, :type => :string
  col :census_division_number, :type => :integer
  col :total_electricity_consumption, :type => :float
  col :total_floorspace, :type => :float
  col :electricity_intensity, :type => :float
end
