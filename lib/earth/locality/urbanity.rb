class Urbanity < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  create_table do
    string 'name'
  end
end
