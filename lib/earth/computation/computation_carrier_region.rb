class ComputationCarrierRegion < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :egrid_subregion, :foreign_key => 'egrid_subregion_abbreviation'

  col :name
  col :computation_carrier_name
  col :region
  col :egrid_subregion_abbreviation
end