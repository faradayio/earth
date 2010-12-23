BusClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
      float  'passengers'
      float  'speed'
      string 'speed_units'
      float  'diesel_intensity'
      string 'diesel_intensity_units'
      float  'alternative_fuels_intensity'
      string 'alternative_fuels_intensity_units'
      float  'air_conditioning_emission_factor'
      string 'air_conditioning_emission_factor_units'
    end
    
    import "a list of bus classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRsSnJoS1hraGJvR012cDROWXFPbVE&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
      store 'passengers'
      store 'speed', :units_field_name => 'speed_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
      store 'alternative_fuels_intensity', :units_field_name => 'alternative_fuels_intensity_units'
      store 'air_conditioning_emission_factor', :units_field_name => 'air_conditioning_emission_factor_units'
    end
    
    verify "Distance, passengers, speed, and diesel intensity should be greater than zero" do
      BusClass.all.each do |bus_class|
        %w{ distance passengers speed diesel_intensity }.each do |attribute|
          value = bus_class.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for BusClass #{bus_class.name}: #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Alternative fuels intensity and air conditioning emission factor should be zero or more" do
      BusClass.all.each do |bus_class|
        %w{ alternative_fuels_intensity air_conditioning_emission_factor }.each do |attribute|
          value = bus_class.send(:"#{attribute}")
          unless value >= 0
            raise "Invalid #{attribute} for BusClass #{bus_class.name}: #{value} (should be >= 0)"
          end
        end
      end
    end
    
    verify "Distance units should be kilometres" do
      BusClass.all.each do |bus_class|
        unless bus_class.distance_units == "kilometres"
          raise "Invalid distance units for BusClass #{bus_class.name}: #{bus_class.distance_units} (should be kilometres)"
        end
      end
    end
    
    verify "Speed units should be kilometres per hour" do
      BusClass.all.each do |bus_class|
        unless bus_class.speed_units == "kilometres_per_hour"
          raise "Invalid speed units for BusClass #{bus_class.name}: #{bus_class.speed_units} (should be kilometres_per_hour)"
        end
      end
    end
    
    verify "Diesel intensity and alternative fuel intensity units should be litres per kilometre" do
      BusClass.all.each do |bus_class|
        %w{ diesel_intensity alternative_fuels_intensity }.each do |attribute|
          units = bus_class.send(:"#{attribute}_units")
          unless units == "litres_per_kilometre"
            raise "Invalid #{attribute}_units for BusClass #{bus_class.name}: #{units} (should be litres_per_kilometre)"
          end
        end
      end
    end
    
    verify "Air conditioning emission factor units should be kilograms per kilometre" do
      BusClass.all.each do |bus_class|
        unless bus_class.air_conditioning_emission_factor_units == "kilograms_per_kilometre"
          raise "Invalid air conditioning emission factor units for BusClass #{bus_class.name}: #{bus_class.air_conditioning_emission_factor_units} (should be kilograms_per_kilometre)"
        end
      end
    end
    
    verify "Fallbacks should satisfy same constraints as data" do
      %w{ distance passengers speed diesel_intensity }.each do |attribute|
        value = BusClass.fallback.send(:"#{attribute}")
        unless value > 0
          raise "Invalid BusClass fallback #{attribute}: #{value} (should be > 0)"
        end
      end
      
      %w{ alternative_fuels_intensity air_conditioning_emission_factor }.each do |attribute|
        value = BusClass.fallback.send(:"#{attribute}")
        unless value >= 0
          raise "Invalid BusClass fallback #{attribute}: #{value} (should be >= 0)"
        end
      end
    end
  end
end
