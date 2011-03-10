class ComputationCarrier < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :name => 'fallback',
                :power_usage_effectiveness => lambda { ComputationCarrier.maximum('power_usage_effectiveness') }
  
  data_miner do
    tap "Brighter Planet's computation carrier data", Earth.taps_server
  end
end
