class AutomobileMakeModelYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make_year,              :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_year_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_year_name'
  has_many :automobiles,                                                               :foreign_key => 'make_model_year_name'
  
  data_miner do
    tap "Brighter Planet's model year data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
