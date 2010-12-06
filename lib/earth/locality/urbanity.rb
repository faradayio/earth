class Urbanity < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  data_miner do
    tap "Brighter Planet's sanitized urbanity data", Earth.taps_server
  end
end
