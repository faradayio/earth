class DataCenterCompany < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's data center company data", Earth.taps_server
  end
end
