class FuelPrice < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel_type, :foreign_key => 'name' # weird
  
  data_miner do
    tap "Brighter Planet's fuel price data", TAPS_SERVER
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
