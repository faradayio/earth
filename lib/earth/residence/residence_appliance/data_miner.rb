ResidenceAppliance.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      float    'annual_energy_from_electricity'
      string   'annual_energy_from_electricity_units'
    end

    process "Derive from residential energy consumption survey responses" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      ResidentialEnergyConsumptionSurveyResponse.column_names.select { |column| column.match(/annual.*_count/) }.map { |column| column.gsub '_count', '' }.each do |appliance_name|
        appliance = find_or_create_by_name appliance_name
        appliance.annual_energy_from_electricity = ResidentialEnergyConsumptionSurveyResponse.weighted_average "annual_energy_from_electricity_for_#{appliance_name.pluralize}"
        appliance.save!
      end
    end
  end
end

