class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized distance class data", Earth.taps_server
  end
end
