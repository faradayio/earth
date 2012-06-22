require 'cohort_analysis'
ClothesMachineUse.class_eval do
  data_miner do
    process "Ensure ResidentialEnergyConsumptionSurveyResponse is populated" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Derive from ResidentialEnergyConsumptionSurveyResponse" do
      ::Earth::Utils.insert_ignore(
        :src => ResidentialEnergyConsumptionSurveyResponse,
        :dest => ClothesMachineUse,
        :cols => { :clothes_washer_use => :name }
      )
    end
    
    # sabshere 5/20/10 weird that this uses cohort
    process "precalculate annual energy use" do
      safe_find_each do |record|
        record.annual_energy_from_electricity_for_clothes_driers = ResidentialEnergyConsumptionSurveyResponse.cohort(:clothes_machine_use_id => record.name).weighted_average :annual_energy_from_electricity_for_clothes_driers
        record.annual_energy_from_electricity_for_clothes_driers_units = 'joules'
        record.save!
      end
    end
  end
end
