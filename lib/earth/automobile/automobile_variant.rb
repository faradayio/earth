class AutomobileVariant < ActiveRecord::Base
  set_primary_key :row_hash
  
  has_many :automobiles, :foreign_key => 'variant_id'
  belongs_to :make,       :class_name => 'AutomobileMake',      :foreign_key => 'make_name'
  belongs_to :model,      :class_name => 'AutomobileModel',     :foreign_key => 'model_name'
  belongs_to :model_year, :class_name => 'AutomobileModelYear', :foreign_key => 'model_year_name'
  belongs_to :fuel_type,  :class_name => 'AutomobileFuelType',  :foreign_key => 'fuel_type_code'

  data_miner do
    tap "Brighter Planet's sanitized automobile variant data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
