class AutomobileModelYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'
  has_many :variants, :class_name => 'AutomobileVariant', :foreign_key => 'model_year_name'
  has_many :automobiles, :foreign_key => 'model_year_id'
  
  data_miner do
    tap "Brighter Planet's model year data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
