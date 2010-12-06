class RailClass < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's rail class data", Earth.taps_server
  end
end
