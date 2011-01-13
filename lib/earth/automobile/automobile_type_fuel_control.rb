class AutomobileTypeFuelControl < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel control data", Earth.taps_server
  end
end
