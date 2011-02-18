BusFuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'fuel_name'
      float  'energy_content'
      string 'energy_content_units'
      float  'co2_emission_factor'
      string 'co2_emission_factor_units'
      float  'co2_biogenic_emission_factor'
      string 'co2_biogenic_emission_factor_units'
      float  'ch4_emission_factor'
      string 'ch4_emission_factor_units'
      float  'n2o_emission_factor'
      string 'n2o_emission_factor_units'
    end
    
    process "Ensure necessary datasets are imported" do
      Fuel.run_data_miner!
      GreenhouseGas.run_data_miner!
      BusFuelYearControl.run_data_miner!
    end
    
    import "a list of bus fuels without emission factors",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdGNscUdpbkdBUmJkTlFxdEtfSEdJS2c&output=csv' do
      key 'name'
      store 'fuel_name'
    end
    
    import "a list of bus fuels and their emission factors",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHAtZ1YyWmxuS1JWUzZYSVhhdUViYmc&output=csv' do
      key   'name'
      store 'fuel_name'
      store 'ch4_emission_factor', :units_field_name => 'ch4_emission_factor_units'
      store 'n2o_emission_factor', :units_field_name => 'n2o_emission_factor_units'
    end
    
    import "energy contents for compressed/liquified natural gas fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDFfdHMycVB6dTkyUFFNM0x4b19TQVE&output=csv' do
      key   'name'
      store 'energy_content', :units_field_name => 'energy_content_units'
    end
    
    process "Convert emission factors to metric units" do
      conversion_factor = (1 / 1.609344) * (1.0 / 1_000.0 ) # Google: 1 mile / 1.609344 km * 1 kg / 1000 g
      gwp_ch4 = GreenhouseGas[:ch4].global_warming_potential
      connection.execute %{
        UPDATE bus_fuels
        SET ch4_emission_factor = ch4_emission_factor * #{conversion_factor} * #{gwp_ch4},
            ch4_emission_factor_units = 'kilograms_co2e_per_kilometre'
        WHERE ch4_emission_factor_units = 'grams_per_mile'
      }
      
      gwp_n2o = GreenhouseGas[:n2o].global_warming_potential
      connection.execute %{
        UPDATE bus_fuels
        SET n2o_emission_factor = n2o_emission_factor * #{conversion_factor} * #{gwp_n2o},
            n2o_emission_factor_units = 'kilograms_co2e_per_kilometre'
        WHERE n2o_emission_factor_units = 'grams_per_mile'
      }
    end
    
    process "Convert energy contents to metric units" do
      conversion_factor = (1 / 947.81712) * (1 / 3.78541178) # Google: 1 MJ / 947.81712 btu * 1 gallon / 3.78541178 l
      connection.execute %{
        UPDATE bus_fuels
        SET energy_content = energy_content * #{conversion_factor},
            energy_content_units = 'megajoules_per_litre'
        WHERE energy_content_units = 'btu_per_gallon'
      }
    end
    
    process 'Calculate CO2 and CO2 biogenic emission factors and units' do
      BusFuel.all.each do |bus_fuel|
        fuel = bus_fuel.fuel
        if bus_fuel.energy_content.present?
          co2_factor = (bus_fuel.energy_content * fuel.carbon_content * fuel.oxidation_factor * (1 - fuel.biogenic_fraction))
          bus_fuel.co2_emission_factor = co2_factor.grams.to(:kilograms).carbon.to(:co2)
          
          co2_prefix = fuel.co2_emission_factor_units.split("_per_")[0]
          co2_suffix = bus_fuel.energy_content_units.split("_per_")[1]
          bus_fuel.co2_emission_factor_units = co2_prefix + "_per_" + co2_suffix
          
          co2_biogenic_factor = (bus_fuel.energy_content * fuel.carbon_content * fuel.oxidation_factor * fuel.biogenic_fraction)
          bus_fuel.co2_biogenic_emission_factor = co2_biogenic_factor.grams.to(:kilograms).carbon.to(:co2)
          
          co2_biogenic_prefix = fuel.co2_biogenic_emission_factor_units.split("_per_")[0]
          co2_biogenic_suffix = bus_fuel.energy_content_units.split("_per_")[1]
          bus_fuel.co2_biogenic_emission_factor_units = co2_biogenic_prefix + "_per_" + co2_biogenic_suffix
        else
          bus_fuel.co2_emission_factor = fuel.co2_emission_factor
          bus_fuel.co2_emission_factor_units = fuel.co2_emission_factor_units
          
          bus_fuel.co2_biogenic_emission_factor = fuel.co2_biogenic_emission_factor
          bus_fuel.co2_biogenic_emission_factor_units = fuel.co2_biogenic_emission_factor_units
        end
        
        bus_fuel.save!
      end
    end
    
    process 'Calculate CH4 and N2O emission factor and units for BusFuels with BusFuelYearControls' do
      BusFuel.all.each do |bus_fuel|
        if bus_fuel.latest_fuel_year_controls.present?
          ch4_factors_by_year = bus_fuel.latest_fuel_year_controls.map do |fyc|
             fyc.total_travel_percent * fyc.fuel_control.ch4_emission_factor
          end
          bus_fuel.ch4_emission_factor = ch4_factors_by_year.sum * GreenhouseGas[:ch4].global_warming_potential
          
          ch4_prefix = bus_fuel.latest_fuel_year_controls.first.fuel_control.ch4_emission_factor_units.split("_per_")[0]
          ch4_suffix = bus_fuel.latest_fuel_year_controls.first.fuel_control.ch4_emission_factor_units.split("_per_")[1]
          bus_fuel.ch4_emission_factor_units = ch4_prefix + "_co2e_per_" + ch4_suffix
          
          n2o_factors_by_year = bus_fuel.latest_fuel_year_controls.map do |fyc|
             fyc.total_travel_percent * fyc.fuel_control.n2o_emission_factor
          end
          bus_fuel.n2o_emission_factor = n2o_factors_by_year.sum * GreenhouseGas[:n2o].global_warming_potential
          
          n2o_prefix = bus_fuel.latest_fuel_year_controls.first.fuel_control.n2o_emission_factor_units.split("_per_")[0]
          n2o_suffix = bus_fuel.latest_fuel_year_controls.first.fuel_control.n2o_emission_factor_units.split("_per_")[1]
          bus_fuel.n2o_emission_factor_units = n2o_prefix + "_co2e_per_" + n2o_suffix
        end
        
        bus_fuel.save!
      end
    end
    
    # FIXME TODO verify fuel_name appears in fuels
    verify "Fuel name should never be missing" do
      BusFuel.all.each do |fuel|
        value = fuel.send(:fuel_name)
        unless value.present?
          puts "Missing fuel name for BusFuel #{fuel.name}"
          fail
        end
      end
    end
    
    verify "Energy content should be greater than zero if present" do
      BusFuel.all.each do |fuel|
        value = fuel.send(:energy_content)
        if value.present?
          unless value > 0
            puts "Invalid energy content for BusFuel #{fuel.name}: #{value} (should be > 0)"
            fail
          end
        end
      end
    end
    
    %w{ co2_emission_factor co2_biogenic_emission_factor }.each do |attribute|
      verify "#{attribute.humanize} should be 0 or more" do
        BusFuel.all.each do |fuel|
          value = fuel.send(attribute)
          unless value >= 0
            puts "Invalid #{attribute.humanize.downcase} for BusFuel #{fuel.name}: #{value} (should be 0 or more)"
            fail
          end
        end
      end
    end
    
    %w{ ch4_emission_factor n2o_emission_factor }.each do |attribute|
      verify "#{attribute.humanize} should be > 0" do
        BusFuel.all.each do |fuel|
          value = fuel.send(attribute)
          unless value > 0
            puts "Invalid #{attribute.humanize.downcase} for BusFuel #{fuel.name}: #{value} (should be > 0)"
            fail
          end
        end
      end
    end
    
    verify "Energy content units should be megajoules per litre if present" do
      BusFuel.all.each do |fuel|
        units = fuel.send(:energy_content_units)
        if units.present?
          unless units == "megajoules_per_litre"
            puts "Invalid energy content units for BusFuel #{fuel.name}: #{units} (should be megajoules_per_litre)"
            fail
          end
        end
      end
    end
    
    [["co2_emission_factor_units", "kilograms_per_litre"],
     ["co2_biogenic_emission_factor_units", "kilograms_per_litre"],
     ["ch4_emission_factor_units", "kilograms_co2e_per_kilometre"],
     ["n2o_emission_factor_units", "kilograms_co2e_per_kilometre"]].each do |pair|
      attribute = pair[0]
      proper_units = pair[1]
      verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
        BusFuel.all.each do |fuel|
          units = fuel.send(:"#{attribute}")
          unless units == proper_units
            puts "Invalid #{attribute.humanize.downcase} for BusFuel #{fuel.name}: #{units} (should be #{proper_units})"
            fail
          end
        end
      end
    end
  end
end
