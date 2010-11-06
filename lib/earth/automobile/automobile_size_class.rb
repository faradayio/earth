class AutomobileSizeClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :automobiles, :foreign_key => 'size_class_name'
  
  falls_back_on :hybrid_fuel_efficiency_city_multiplier => 1.651, # https://brighterplanet.sifterapp.com/issue/667
                :hybrid_fuel_efficiency_highway_multiplier => 1.213,
                :conventional_fuel_efficiency_city_multiplier => 0.987,
                :conventional_fuel_efficiency_highway_multiplier => 0.996
  
  data_miner do
    tap "Brighter Planet's sanitized automobile size class data", Earth.taps_server
  end
end
