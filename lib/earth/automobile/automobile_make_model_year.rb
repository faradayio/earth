class AutomobileMakeModelYear < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip to look up auto fuel and alt auto fuel
  belongs_to :automobile_fuel,     :foreign_key => 'fuel_code',     :primary_key => 'code'
  belongs_to :alt_automobile_fuel, :foreign_key => 'alt_fuel_code', :primary_key => 'code', :class_name => 'AutomobileFuel'
  
  col :name
  col :make_name
  col :model_name
  col :year, :type => :integer
  col :hybridity,:type => :boolean
  col :fuel_code
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  col :alt_fuel_code
  col :alt_fuel_efficiency_city, :type => :float
  col :alt_fuel_efficiency_city_units
  col :alt_fuel_efficiency_highway, :type => :float
  col :alt_fuel_efficiency_highway_units
  col :type_name # whether the vehicle is a passenger car or light-duty truck
  col :weighting, :type => :float # for calculating AutomobileMakeModel fuel efficiencies
  
  warn_unless_size 10997
  warn_if_nulls_except :alt_fuel_code
  warn_if_nulls /alt_fuel_efficiency/, :conditions => 'alt_fuel_code IS NOT NULL'
end
