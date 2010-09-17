class CensusDivision < ActiveRecord::Base
  set_primary_key :number
  
  belongs_to :census_region, :foreign_key => 'census_region_number'
  has_many :states, :foreign_key => 'census_division_number'
  has_many :zip_codes, :through => :states
  has_many :climate_divisions, :through => :states
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_division_number'
  
  falls_back_on :meeting_building_natural_gas_intensity => 0.011973,
                :meeting_building_fuel_oil_intensity => 0.0037381,
                :meeting_building_electricity_intensity => 0.072444,
                :meeting_building_district_heat_intensity => 3458.7
  
  data_miner do
    tap "Brighter Planet's sanitized census divisions", Earth.taps_server

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
