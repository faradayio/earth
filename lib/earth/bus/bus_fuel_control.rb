class BusFuelControl < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized bus fuel data", Earth.taps_server
  end
end
