require 'earth/fuel'
class AutomobileSizeClass < ActiveRecord::Base
  self.primary_key = "name"
  
  # FIXME TODO clean up size class in MakeModelYearVariant, derive size class for MakeModelYear, and calculate this from MakeModelYear
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

  warn_if_nulls_except(
    :hybrid_fuel_efficiency_city_multiplier,
    :hybrid_fuel_efficiency_highway_multiplier,
    :conventional_fuel_efficiency_city_multiplier,
    :conventional_fuel_efficiency_highway_multiplier
  )


  warn_unless_size 15
end
