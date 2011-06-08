class AutomobileSizeClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :hybrid_fuel_efficiency_city_multiplier => 1.651, # https://brighterplanet.sifterapp.com/issue/667
                :hybrid_fuel_efficiency_highway_multiplier => 1.213,
                :conventional_fuel_efficiency_city_multiplier => 0.987,
                :conventional_fuel_efficiency_highway_multiplier => 0.996
  
  create_table do
    string 'name'
    string 'type_name'
    float  'annual_distance'
    string 'annual_distance_units'
    float  'fuel_efficiency_city'
    string 'fuel_efficiency_city_units'
    float  'fuel_efficiency_highway'
    string 'fuel_efficiency_highway_units'
    float  'hybrid_fuel_efficiency_city_multiplier'
    float  'hybrid_fuel_efficiency_highway_multiplier'
    float  'conventional_fuel_efficiency_city_multiplier'
    float  'conventional_fuel_efficiency_highway_multiplier'
  end
end
