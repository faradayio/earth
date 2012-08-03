require 'earth/residence/residential_energy_consumption_survey_response'

ResidenceAppliance.class_eval do
  data_miner do
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.column_names.grep(/_count$/).each do |column_name|
        appliance_name = column_name.sub '_count', ''
        appliance = find_or_create_by_name appliance_name
        appliance.annual_energy_from_electricity = ResidentialEnergyConsumptionSurveyResponse.weighted_average "annual_energy_from_electricity_for_#{appliance_name.pluralize}"
        appliance.save!
      end
    end
  end
end

