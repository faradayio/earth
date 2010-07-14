class AutomobileModel < ActiveRecord::Base
  set_primary_key :name
  
  has_many :variants, :class_name => 'AutomobileVariant', :foreign_key => 'model_name'
  belongs_to :make, :class_name => 'AutomobileMake', :foreign_key => 'make_name'
  
  data_miner do
    tap "Brighter Planet's auto model data", TAPS_SERVER
    
    process "bring in dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
