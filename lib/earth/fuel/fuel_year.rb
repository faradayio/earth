class FuelYear < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's fuel year data", Earth.taps_server
  end
end
