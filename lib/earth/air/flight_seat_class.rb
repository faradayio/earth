class FlightSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :multiplier => 1
  
  data_miner do
    tap "Brighter Planet's sanitized flight seat class data", Earth.taps_server
  end
end
