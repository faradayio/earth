AutomobileTypeYear.class_eval do
  data_miner do
    import "automobile type year air conditioning emissions derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFoyTWhDeHpndTV5Ny1aX0sxR1ljSFE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'type_name'
      store 'year'
      store 'hfc_emissions', :units_field_name => 'hfc_emissions_units'
    end
    
    process "Ensure AutomobileTypeFuelYear is populated" do
      AutomobileTypeFuelYear.run_data_miner!
    end
    
    process "Calculate HFC emission factor from AutomobileTypeFuelYear" do
      AutomobileTypeYear.all.each do |record|
        record.hfc_emission_factor = record.hfc_emissions / record.type_fuel_years.sum('fuel_consumption')
        record.hfc_emission_factor_units = "kilograms_co2e_per_litre"
        record.save
      end
    end    
  end
end
