class FlightDomesticity < ActiveRecord::Base
  set_primary_key :name
  data_miner do
    tap "Brighter Planet's flight domesticity info", TAPS_SERVER
  end
end
