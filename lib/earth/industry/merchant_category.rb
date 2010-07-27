class MerchantCategory < ActiveRecord::Base
  set_primary_key :mcc
  
  data_miner do
    tap "Brighter Planet's merchant category data", Earth.taps_server
  end
end
