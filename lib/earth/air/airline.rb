class Airline < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's sanitized airlines data", Earth.taps_server
  end
end
