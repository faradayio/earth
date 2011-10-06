RailFuel.class_eval do
  data_miner do
    import "Rail diesel CH4 and N2O emission factors from the EPA GHG Inventory",
           :url => 'https://docs.google.com/spreadsheet/pub?hl=en_US&hl=en_US&key=0AoQJbWqPrREqdEppYmtaU2k2Y0k0TS1MaW9iUm16amc&output=csv' do
      key 'name'
      store 'fuel_name'
      store 'ch4_emission_factor', :units_field_name => 'ch4_emission_factor_units'
      store 'n2o_emission_factor', :units_field_name => 'n2o_emission_factor_units'
    end
    
    process "Ensure Fuel and GreenhouseGas are populated" do
      Fuel.run_data_miner!
      GreenhouseGas.run_data_miner!
    end
    
    process "Convert ch4 and n2o emission factor units to kg co2e / l" do
      RailFuel.find_each do |fuel|
        if fuel.ch4_emission_factor_units == "grams_per_kilogram" and fuel.density_units == "kilograms_per_litre"
          fuel.ch4_emission_factor = GreenhouseGas["ch4"].global_warming_potential * fuel.density * fuel.ch4_emission_factor / 1000.0
          fuel.ch4_emission_factor_units = "kilograms_co2e_per_litre"
          fuel.save!
        else
          raise "We don't know how to perform this unit conversion."
        end
        
        if fuel.n2o_emission_factor_units == "grams_per_kilogram" and fuel.density_units == "kilograms_per_litre"
          fuel.n2o_emission_factor = GreenhouseGas["n2o"].global_warming_potential * fuel.density * fuel.n2o_emission_factor / 1000.0
          fuel.n2o_emission_factor_units = "kilograms_co2e_per_litre"
          fuel.save!
        else
          raise "We don't know how to perform this unit conversion."
        end
      end
    end
  end
end
