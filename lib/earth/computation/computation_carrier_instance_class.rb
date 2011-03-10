class ComputationCarrierInstanceClass < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :computation_carrier, :foreign_key => 'computation_carrier_name'
  
  falls_back_on :name => 'fallback',
                :electricity_intensity => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity },
                :electricity_intensity_units => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity_units }
  
  data_miner do
    tap "Brighter Planet's computation carrier instance class data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
