class AutomobileSizeClassYear < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized automobile size class year data", Earth.taps_server
  end
end
