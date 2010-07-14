class Urbanity < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residences
  has_many :residential_energy_consumption_survey_responses

  data_miner do
    schema do
      string :name
    end

    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO urbanities(name)
        SELECT DISTINCT residential_energy_consumption_survey_responses.urbanity_id FROM residential_energy_consumption_survey_responses WHERE LENGTH(residential_energy_consumption_survey_responses.urbanity_id) > 0
      }
    end
  end
end
