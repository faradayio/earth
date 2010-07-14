class ResidenceFuelPrice < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 5 # ? FIXME
  
  belongs_to :fuel, :class_name => 'ResidenceFuelType', :foreign_key => 'residence_fuel_type_name'
  belongs_to :locatable, :polymorphic => true
  
  data_miner do
    tap "Brighter Planet's residence fuel price data", TAPS_SERVER

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end

end
