class Fuel < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's global fuel data", Earth.taps_server
  end
end
