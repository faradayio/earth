Urbanity.class_eval do
  data_miner do
    schema do
      string 'name'
    end
    
    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      INSERT_IGNORE %{INTO urbanities(name)
        SELECT DISTINCT recs_responses.urbanity_id FROM recs_responses WHERE LENGTH(recs_responses.urbanity_id) > 0
      }
    end
  end
end
