AutomobileActivityYearType.class_eval do
  data_miner do
    import "annual automobile air conditioning emissions derived from the 2010 EPA GHG Inventory",
           :url => "file://#{Earth::DATA_DIR}/automobile/hfc_emissions.csv" do
      key   'name'
      store 'activity_year'
      store 'type_name'
      store 'hfc_emissions', :from_units => :teragrams_co2e, :to_units => :kilograms_co2e
    end
    
    process "Ensure AutomobileActivityYearTypeFuel is populated" do
      AutomobileActivityYearTypeFuel.run_data_miner!
    end
    
    process "Derive hfc emission factor from AutomobileActivityYearTypeFuel" do
      safe_find_each do |ayt|
        ayt.update_attributes!(
          :hfc_emission_factor => ayt.hfc_emissions / ayt.activity_year_type_fuels.sum(:distance),
          :hfc_emission_factor_units => ayt.hfc_emissions_units + '_per_' + ayt.activity_year_type_fuels.first.distance_units.singularize
        )
      end
    end
  end
end
