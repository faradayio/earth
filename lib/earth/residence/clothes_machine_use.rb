class ClothesMachineUse < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residences
  has_many :residential_energy_consumption_survey_responses

  data_miner do
    schema do
      string 'name'
      float  'annual_energy_from_electricity_for_clothes_driers'
      string 'annual_energy_from_electricity_for_clothes_driers_units'
    end

    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO clothes_machine_uses(name)
        SELECT DISTINCT residential_energy_consumption_survey_responses.clothes_washer_use FROM residential_energy_consumption_survey_responses WHERE LENGTH(residential_energy_consumption_survey_responses.clothes_washer_use) > 0
      }
    end

    # sabshere 5/20/10 weird that this uses cohort
    process "precalculate annual energy use" do
      find_in_batches do |batch|
        batch.each do |record|
          record.annual_energy_from_electricity_for_clothes_driers = ResidentialEnergyConsumptionSurveyResponse.big_cohort(:clothes_machine_use => record).weighted_average :annual_energy_from_electricity_for_clothes_driers
          record.annual_energy_from_electricity_for_clothes_driers_units = 'joules'
          record.save!
        end
      end
    end
  end
end
