class CensusRegion < ActiveRecord::Base
  self.primary_key = :number
  
  has_many :census_divisions, :foreign_key => 'census_region_number'
  has_many :states, :through => :census_divisions
  # has_many :climate_divisions, :through => :census_divisions
  # has_many :zip_codes, :through => :census_divisions
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_region_number'
  
  col :number, :type => :integer
  col :name
end
