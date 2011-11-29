class Urbanity < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  col :name
end