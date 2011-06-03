ClothesMachineUse.class_eval do
  data_miner do
    schema do
      string 'name'
      float  'annual_energy_from_electricity_for_clothes_driers'
      string 'annual_energy_from_electricity_for_clothes_driers_units'
    end
    
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      INSERT_IGNORE %{INTO clothes_machine_uses(name)
        SELECT DISTINCT recs_responses.clothes_washer_use FROM recs_responses WHERE LENGTH(recs_responses.clothes_washer_use) > 0
      }
    end
    
    # sabshere 5/20/10 weird that this uses cohort
    process "precalculate annual energy use" do
      find_in_batches do |batch|
        batch.each do |record|
          record.annual_energy_from_electricity_for_clothes_driers = ResidentialEnergyConsumptionSurveyResponse.big_cohort(:clothes_machine_use_id => record.name).weighted_average :annual_energy_from_electricity_for_clothes_driers
          record.annual_energy_from_electricity_for_clothes_driers_units = 'joules'
          record.save!
        end
      end
    end
  end
end
