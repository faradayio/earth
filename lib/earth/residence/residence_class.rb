class ResidenceClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residences
  has_many :residential_energy_consumption_survey_responses

  CLASSIFICATIONS = ['mobile home', 'house', 'apartment']

  def classification
    CLASSIFICATIONS.detect { |c| name.downcase.include? c }
  end

  data_miner do
    schema do
      string :name
    end

    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO residence_classes(name)
        SELECT DISTINCT residential_energy_consumption_survey_responses.residence_class_id FROM residential_energy_consumption_survey_responses WHERE LENGTH(residential_energy_consumption_survey_responses.residence_class_id) > 0
      }
    end
  end
end
