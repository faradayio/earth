class Carrier < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's shipping company data", Earth.taps_server
  end
end
