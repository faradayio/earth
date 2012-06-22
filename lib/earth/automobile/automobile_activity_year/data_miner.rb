AutomobileActivityYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileActivityYearType is populated" do
      AutomobileActivityYearType.run_data_miner!
    end
    
    process "Derive from AutomobileActivityYearType" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileActivityYearType,
        :dest => AutomobileActivityYear,
        :cols => { :activity_year => :activity_year }
      )
    end
    
    process "Derive hfc emission factor from AutomobileActivityYearType" do
      safe_find_each do |ay|
        ay.update_attributes!(
          :hfc_emission_factor => ay.activity_year_types.sum(&:hfc_emissions) / ay.activity_year_types.sum{ |ayt| ayt.activity_year_type_fuels.sum(&:distance) },
          :hfc_emission_factor_units => ay.activity_year_types.first.hfc_emission_factor_units
        )
      end
    end
  end
end
