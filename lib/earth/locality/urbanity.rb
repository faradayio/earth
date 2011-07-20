class Urbanity < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  force_schema do
    string 'name'
  end
end
