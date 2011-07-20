class ComputationCarrierRegion < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :egrid_subregion, :foreign_key => 'egrid_subregion_abbreviation'

  force_schema do
    string 'name'
    string 'computation_carrier_name'
    string 'region'
    string 'egrid_subregion_abbreviation'
  end
end
