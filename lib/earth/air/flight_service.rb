class FlightService < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized flight service data", Earth.taps_server
  end
end
