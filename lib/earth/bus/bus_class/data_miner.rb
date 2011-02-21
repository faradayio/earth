BusClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
      float  'passengers'
      float  'speed'
      string 'speed_units'
      float  'gasoline_intensity'
      string 'gasoline_intensity_units'
      float  'diesel_intensity'
      string 'diesel_intensity_units'
      float  'cng_intensity'
      string 'cng_intensity_units'
      float  'lng_intensity'
      string 'lng_intensity_units'
      float  'lpg_intensity'
      string 'lpg_intensity_units'
      float  'methanol_intensity'
      string 'methanol_intensity_units'
      float  'biodiesel_intensity'
      string 'biodiesel_intensity_units'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
      float  'air_conditioning_emission_factor'
      string 'air_conditioning_emission_factor_units'
      float  'alternative_fuels_intensity'
      string 'alternative_fuels_intensity_units'
    end
    
    import "a list of bus classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdGRsSnJoS1hraGJvR012cDROWXFPbVE&output=csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
      store 'passengers'
      store 'speed', :units_field_name => 'speed_units'
      store 'gasoline_intensity', :units_field_name => 'gasoline_intensity_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
      store 'cng_intensity', :units_field_name => 'cng_intensity_units'
      store 'lng_intensity', :units_field_name => 'lng_intensity_units'
      store 'lpg_intensity', :units_field_name => 'lpg_intensity_units'
      store 'methanol_intensity', :units_field_name => 'methanol_intensity_units'
      store 'biodiesel_intensity', :units_field_name => 'biodiesel_intensity_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'air_conditioning_emission_factor', :units_field_name => 'air_conditioning_emission_factor_units'
      store 'alternative_fuels_intensity', :units_field_name => 'alternative_fuels_intensity_units'
    end
    
    verify "Some attributes should be greater than zero" do
      BusClass.all.each do |bus_class|
        %w{ distance passengers speed diesel_intensity air_conditioning_emission_factor }.each do |attribute|
          value = bus_class.send(:"#{attribute}")
          unless value > 0
            puts "Invalid #{attribute.humanize.downcase} for BusClass #{bus_class.name}: #{value} (should be > 0)"
            fail
          end
        end
      end
    end
    
    verify "Some attributes should be zero or more" do
      BusClass.all.each do |bus_class|
        %w{ gasoline_intensity cng_intensity lng_intensity lpg_intensity methanol_intensity biodiesel_intensity electricity_intensity alternative_fuels_intensity }.each do |attribute|
          value = bus_class.send(:"#{attribute}")
          unless value >= 0
            puts "Invalid #{attribute.humanize.downcase} for BusClass #{bus_class.name}: #{value} (should be >= 0)"
            fail
          end
        end
      end
    end
    
    verify "Units should be correct" do
      BusClass.all.each do |bus_class|
        [["distance_units", "kilometres"],
         ["speed_units", "kilometres_per_hour"],
         ["diesel_intensity_units", "litres_per_kilometre"],
         ["gasoline_intensity_units", "litres_per_kilometre"],
         ["cng_intensity_units", "litres_per_kilometre"],
         ["lng_intensity_units", "litres_per_kilometre"],
         ["lpg_intensity_units", "litres_per_kilometre"],
         ["methanol_intensity_units", "litres_per_kilometre"],
         ["biodiesel_intensity_units", "litres_per_kilometre"],
         ["electricity_intensity_units", "kilowatt_hours_per_kilometre"],
         ["air_conditioning_emission_factor_units", "kilograms_co2e_per_kilometre"],
         ["alternative_fuels_intensity_units", "litres_per_kilometre"]].each do |pair|
          attribute = pair[0]
          proper_units = pair[1]
          units = bus_class.send(:"#{attribute}")
          unless units == proper_units
            puts "Invalid #{attribute.humanize.downcase} for BusClass #{bus_class.name}: #{units} (should be #{proper_units})"
            fail
          end
        end
      end
    end
    
    verify "Fallbacks should satisfy same constraints as data" do
      %w{ distance passengers speed diesel_intensity air_conditioning_emission_factor }.each do |attribute|
        value = BusClass.fallback.send(:"#{attribute}")
        unless value > 0
          puts "Invalid #{attribute.humanize.downcase} for fallback BusClass: #{value} (should be > 0)"
          fail
        end
      end
      
      %w{ gasoline_intensity cng_intensity lng_intensity lpg_intensity methanol_intensity biodiesel_intensity electricity_intensity alternative_fuels_intensity }.each do |attribute|
        value = BusClass.fallback.send(:"#{attribute}")
        unless value >= 0
          puts "Invalid #{attribute.humanize.downcase} for fallback BusClass: #{value} (should be >= 0)"
          fail
        end
      end
      
      [["distance_units", "kilometres"],
       ["speed_units", "kilometres_per_hour"],
       ["diesel_intensity_units", "litres_per_kilometre"],
       ["gasoline_intensity_units", "litres_per_kilometre"],
       ["cng_intensity_units", "litres_per_kilometre"],
       ["lng_intensity_units", "litres_per_kilometre"],
       ["lpg_intensity_units", "litres_per_kilometre"],
       ["methanol_intensity_units", "litres_per_kilometre"],
       ["biodiesel_intensity_units", "litres_per_kilometre"],
       ["electricity_intensity_units", "kilowatt_hours_per_kilometre"],
       ["air_conditioning_emission_factor_units", "kilograms_co2e_per_kilometre"],
       ["alternative_fuels_intensity_units", "litres_per_kilometre"]].each do |pair|
        attribute = pair[0]
        proper_units = pair[1]
        units = BusClass.fallback.send(:"#{attribute}")
        unless units == proper_units
          puts "Invalid #{attribute.humanize.downcase} for fallback BusClass: #{units} (should be #{proper_units})"
          fail
        end
      end
    end
  end
end
