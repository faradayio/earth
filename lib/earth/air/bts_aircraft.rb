class BtsAircraft < ActiveRecord::Base
  set_primary_key :bts_code
  
  data_miner do
    tap "Brighter Planet's BTS Aircraft data", Earth.taps_server
  end
end
