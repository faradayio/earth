class ComputationCarrier < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :name => 'fallback',
                :power_usage_effectiveness => lambda { ComputationCarrier.maximum('power_usage_effectiveness') }
  
  create_table do
    string 'name'
    float  'power_usage_effectiveness'
  end
end
