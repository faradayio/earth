class FlightConfiguration < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's flight configuration data", Earth.taps_server
  end
end
