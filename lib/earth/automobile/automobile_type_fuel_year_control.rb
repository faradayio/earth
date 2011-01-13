class AutomobileTypeFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel year control data", Earth.taps_server
  end
end
