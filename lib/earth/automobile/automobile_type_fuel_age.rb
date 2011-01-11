class AutomobileTypeFuelAge < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel age", Earth.taps_server
  end
end
