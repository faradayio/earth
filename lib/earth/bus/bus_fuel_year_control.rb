class BusFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel_control, :class_name => 'BusFuelControl', :foreign_key => 'bus_fuel_control_name'
  
  data_miner do
    tap "Brighter Planet's sanitized bus fuel data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
