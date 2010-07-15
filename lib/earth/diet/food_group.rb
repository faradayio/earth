class FoodGroup < ActiveRecord::Base
  set_primary_key :name
  
  extend Cacheable if Switches.caching?
  
  data_miner do
    tap "Brighter Planet's food group data", Earth.taps_server
  end
end
