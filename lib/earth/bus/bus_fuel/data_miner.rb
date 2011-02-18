BusFuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'fuel_name'
      float  'energy_content'
      string 'energy_content_units'
      float  'ch4_emission_factor'
      string 'ch4_emission_factor_units'
      float  'n2o_emission_factor'
      string 'n2o_emission_factor_units'
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
      connection.execute %{
        UPDATE bus_fuels
        SET ch4_emission_factor = ch4_emission_factor * #{conversion_factor},
            ch4_emission_factor_units = 'kilograms_per_kilometre'
        WHERE ch4_emission_factor_units = 'grams_per_mile'
      }
      
      connection.execute %{
        UPDATE bus_fuels
        SET n2o_emission_factor = n2o_emission_factor * #{conversion_factor},
            n2o_emission_factor_units = 'kilograms_per_kilometre'
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
    
    # FIXME TODO verify fuel_name appears in fuels
    %w{ fuel_name }.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        BusFuel.all.each do |fuel|
          value = fuel.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute.humanize.downcase} for BusFuel #{fuel.name}"
          end
        end
      end
    end
    
    %w{ energy_content ch4_emission_factor n2o_emission_factor }.each do |attribute|
      verify "#{attribute.humanize} should be greater than zero if present" do
        BusFuel.all.each do |fuel|
          value = fuel.send(:"#{attribute}")
          if value.present?
            unless value > 0
              raise "Invalid #{attribute.humanize.downcase} for BusFuel #{fuel.name}: #{value} (should be > 0)"
            end
          end
        end
      end
    end
    
    [["energy_content_units", "megajoules_per_litre"],
     ["ch4_emission_factor_units", "kilograms_per_kilometre"],
     ["n2o_emission_factor_units", "kilograms_per_kilometre"]].each do |pair|
      attribute = pair[0]
      proper_units = pair[1]
      verify "#{attribute.humanize} should be #{proper_units.humanize.downcase} if present" do
        BusFuel.all.each do |fuel|
          units = fuel.send(:"#{attribute}")
          if units.present?
            unless units == proper_units
              raise "Invalid #{attribute.humanize.downcase} for BusFuel #{fuel.name}: #{units} (should be #{proper_units})"
            end
          end
        end
      end
    end
  end
end
