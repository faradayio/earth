RailClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'description'
      float  'passengers'
      float  'distance'
      string 'distance_units'
      float  'speed'
      string 'speed_units'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
      float  'diesel_intensity'
      string 'diesel_intensity_units'
    end
    
    process "Define some unit conversions" do
      Conversions.register :gallons_per_mile, :litres_per_kilometre, 2.35214583
    end

    import "a list of rail classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRYaDNvRXMtZGoxNmRiOHlNWGV6b2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'description'
      store 'passengers'
      store 'distance', :units_field_name => 'distance_units'
      store 'speed', :units_field_name => 'speed_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
    end
    
    verify "Passengers, distance, speed, and electricity intensity should be greater than zero" do
      RailClass.all.each do |rail_class|
        %w{ passengers distance speed electricity_intensity }.each do |attribute|
          value = rail_class.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for RailClass #{rail_class.name}: #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Distance units should be kilometres" do
      RailClass.all.each do |rail_class|
        unless rail_class.distance_units == "kilometres"
          raise "Invalid distance units for RailClass #{rail_class.name}: #{rail_class.distance_units} (should be kilometres)"
        end
      end
    end
    
    verify "Speed units should be kilometres per hour" do
      RailClass.all.each do |rail_class|
        unless rail_class.speed_units == "kilometres_per_hour"
          raise "Invalid speed units for RailClass #{rail_class.name}: #{rail_class.speed_units} (should be kilometres_per_hour)"
        end
      end
    end
    
    verify "Electricity intensity units should be kilowatt hours per kilometre" do
      RailClass.all.each do |rail_class|
        unless rail_class.electricity_intensity_units == "kilowatt_hours_per_kilometre"
          raise "Invalid electricity intensity units for RailClass #{rail_class.name}: #{rail_class.electricity_intensity_units} (should be kilowatt_hours_per_kilometre)"
        end
      end
    end
    
    verify "Diesel intensity should be zero or more" do
      RailClass.all.each do |rail_class|
        unless rail_class.diesel_intensity >= 0
          raise "Invalid diesel intensity for RailClass #{rail_class.name}: #{rail_class.diesel_intensity} (should be > 0)"
        end
      end
    end
    
    verify "Diesel intensity units should be litres per kilometre" do
      RailClass.all.each do |rail_class|
        unless rail_class.diesel_intensity_units == "litres_per_kilometre"
          raise "Invalid distance units for RailClass #{rail_class.name}: #{rail_class.diesel_intensity_units} (should be litres_per_kilometre)"
        end
      end
    end
  end
end
