class GreenhouseGas < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's greenhouse gas data", Earth.taps_server
  end
end
