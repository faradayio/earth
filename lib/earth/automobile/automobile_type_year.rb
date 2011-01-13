class AutomobileTypeYear < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type year data", Earth.taps_server
  end
end
