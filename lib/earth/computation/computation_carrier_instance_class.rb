class ComputationCarrierInstanceClass < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :computation_carrier, :foreign_key => 'computation_carrier_name'
  
  falls_back_on :name => 'fallback',
                :electricity_intensity => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity },
                :electricity_intensity_units => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity_units }
  
  create_table do
    string 'name'
    string 'computation_carrier_name'
    string 'instance_class'
    float  'electricity_intensity'
    string 'electricity_intensity_units'
  end
end
