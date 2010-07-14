class AutomobileMakeYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make, :class_name => 'AutomobileMake', :foreign_key => 'make_name'
  has_many :fleet_years, :class_name => 'AutomobileMakeFleetYear', :foreign_key => 'make_year_name'

  data_miner do
    tap "Brighter Planet's make year data", TAPS_SERVER
    
    process "bring in dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
