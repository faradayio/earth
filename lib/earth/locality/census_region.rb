class CensusRegion < ActiveRecord::Base
  set_primary_key :number
  
  has_many :census_divisions, :foreign_key => 'census_region_number'
  has_many :states, :through => :census_divisions
  # has_many :climate_divisions, :through => :census_divisions
  # has_many :zip_codes, :through => :census_divisions
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_region_number'
  
  data_miner do
    tap "Brighter Planet's sanitized census regions", Earth.taps_server
  end
end
