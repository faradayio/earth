DishwasherUse.class_eval do
  data_miner do
    schema do
      string 'name'
      float 'annual_energy_from_electricity_for_dishwashers'
      string 'annual_energy_from_electricity_for_dishwashers_units'
    end
    
    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO dishwasher_uses(name)
        SELECT DISTINCT residential_energy_consumption_survey_responses.dishwasher_use_id FROM residential_energy_consumption_survey_responses WHERE LENGTH(residential_energy_consumption_survey_responses.dishwasher_use_id) > 0
      }
    end
    
    # sabshere 5/25/10 weird that this uses cohort
    process "precalculate annual energy" do
      find_in_batches do |batch|
        batch.each do |record|
          record.annual_energy_from_electricity_for_dishwashers = ResidentialEnergyConsumptionSurveyResponse.big_cohort(:dishwasher_use => record).weighted_average :annual_energy_from_electricity_for_dishwashers
          record.annual_energy_from_electricity_for_dishwashers_units = 'joules'
          record.save!
        end
      end
    end
  end
end
