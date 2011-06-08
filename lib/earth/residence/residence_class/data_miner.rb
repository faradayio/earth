ResidenceClass.class_eval do
  data_miner do
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      INSERT_IGNORE %{INTO residence_classes(name)
        SELECT DISTINCT recs_responses.residence_class_id FROM recs_responses WHERE LENGTH(recs_responses.residence_class_id) > 0
      }
    end
  end
end
