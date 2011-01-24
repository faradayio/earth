ResidenceClass.class_eval do
  data_miner do
    schema do
      string :name
    end
    
    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO residence_classes(name)
        SELECT DISTINCT recs_responses.residence_class_id FROM recs_responses WHERE LENGTH(recs_responses.residence_class_id) > 0
      }
    end
  end
end
