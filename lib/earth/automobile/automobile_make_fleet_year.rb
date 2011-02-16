class AutomobileMakeFleetYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',     :foreign_key => 'make_name'
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'
  
  data_miner do
    tap "Brighter Planet's sanitized auto make fleet year data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
