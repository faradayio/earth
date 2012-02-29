require 'cohort_analysis'
DishwasherUse.class_eval do
  data_miner do
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      ::Earth::Utils.insert_ignore(
        :src => ResidentialEnergyConsumptionSurveyResponse,
        :dest => DishwasherUse,
        :cols => { :dishwasher_use_id => :name }
      )
    end
    
    # sabshere 5/25/10 weird that this uses cohort
    process "precalculate annual energy" do
      find_each do |record|
        record.annual_energy_from_electricity_for_dishwashers = ResidentialEnergyConsumptionSurveyResponse.cohort(:dishwasher_use_id => record.name).weighted_average :annual_energy_from_electricity_for_dishwashers
        record.annual_energy_from_electricity_for_dishwashers_units = 'joules'
        record.save!
      end
    end
  end
end
