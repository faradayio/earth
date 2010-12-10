class Carrier < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :corporate_emission_factor => 0.318#Carrier.average(:corporate_emission_factor)
  
  data_miner do
    tap "Brighter Planet's shipping company data", Earth.taps_server
  end
end
