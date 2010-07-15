class EgridSubregion < ActiveRecord::Base
  set_primary_key :abbreviation
  
  has_many :zip_codes, :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  
  falls_back_on :electricity_emission_factor => 1.404.pounds.to(:kilograms) # kg CO2 / kWh https://brighterplanet.sifterapp.com/projects/30/issues/437?return_uri=%2Fprojects%2F30%2Fissues%3Fa%3D79%26s%3D1-2
  
  data_miner do
    tap "Brighter Planet's egrid subregion data", Earth.taps_server

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
