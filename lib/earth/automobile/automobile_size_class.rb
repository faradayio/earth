class AutomobileSizeClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :hybrid_fuel_efficiency_city_multiplier => 1.651, # https://brighterplanet.sifterapp.com/issue/667
                :hybrid_fuel_efficiency_highway_multiplier => 1.213,
                :conventional_fuel_efficiency_city_multiplier => 0.987,
                :conventional_fuel_efficiency_highway_multiplier => 0.996
  
  col :name
  col :type_name
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  col :hybrid_fuel_efficiency_city_multiplier, :type => :float
  col :hybrid_fuel_efficiency_highway_multiplier, :type => :float
  col :conventional_fuel_efficiency_city_multiplier, :type => :float
  col :conventional_fuel_efficiency_highway_multiplier, :type => :float
end