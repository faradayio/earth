class AutomobileMakeFleetYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make, :class_name => 'AutomobileMake', :foreign_key => 'make_name'
  # WRONG belongs_to :model_year, :class_name => 'AutomobileModelYear', :foreign_key => 'automobile_model_year_name'
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'

  data_miner do
    tap "Brighter Planet's sanitized auto make fleet year data", TAPS_SERVER
    
    process "bring in dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
