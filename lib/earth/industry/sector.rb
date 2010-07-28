class Sector < ActiveRecord::Base
  set_primary_key :io_code
  
  data_miner do
    tap "Brighter Planet's input-output sector data", Earth.taps_server
  end
end
