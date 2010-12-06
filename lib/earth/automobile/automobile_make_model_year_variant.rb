class AutomobileMakeModelYearVariant < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :make,            :class_name => 'AutomobileMake',          :foreign_key => 'make_name'
  belongs_to :make_model,      :class_name => 'AutomobileMakeModel',     :foreign_key => 'make_model_name'
  belongs_to :make_model_year, :class_name => 'AutomobileMakeModelYear', :foreign_key => 'make_model_year_name'
  belongs_to :fuel_type,       :class_name => 'AutomobileFuelType',      :foreign_key => 'fuel_type_code'

  data_miner do
    tap "Brighter Planet's sanitized automobile make model year variant data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
