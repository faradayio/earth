AutomobileYear.class_eval do
  data_miner do
    process "Ensure AutomobileMakeModelYearVariant is populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
    end
    
    process "Derive year names from AutomobileMakeModelYearVariant" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileYear,
        :cols => { :year => :year }
      )
    end
  end
end
