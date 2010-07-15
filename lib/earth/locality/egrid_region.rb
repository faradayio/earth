class EgridRegion < ActiveRecord::Base
  set_primary_key :name
  
  has_many :egrid_subregions, :foreign_key => 'egrid_region_name'
  
  data_miner do
    tap "Brighter Planet's egrid region data", Earth.taps_server

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  falls_back_on :loss_factor => 0.061311 # Ian
end
