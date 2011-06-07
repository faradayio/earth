AirConditionerUse.class_eval do
  data_miner do
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      INSERT_IGNORE %{INTO air_conditioner_uses(name)
        SELECT DISTINCT recs_responses.central_ac_use FROM recs_responses WHERE LENGTH(recs_responses.central_ac_use) > 0
      }
    end
    
    import "Ian's precalculated fugitive emissions values", :url => 'http://spreadsheets.google.com/pub?key=ri_380yQZAqBKeqie_TECgg&gid=0&output=csv' do
      key 'name', :field_name => 'air_conditioner_use_name'
      store 'fugitive_emission', :units_field_name => 'unit', :to_units => :kilograms_per_square_metre
    end
  end
end
