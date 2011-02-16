class AutomobileMakeModel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,                   :class_name => 'AutomobileMake',                 :foreign_key => 'make_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_name'
  
  data_miner do
    tap "Brighter Planet's auto model data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
