AircraftClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'code'
      float   'm3'
      string  'm3_units'
      float   'm2'
      string  'm2_units'
      float   'm1'
      string  'm1_units'
      float   'b'
      string  'b_units'
      float   'seats'
    end
    
    process "Derive aircraft classes from Aircraft" do
      Aircraft.run_data_miner!
      connection.select_values("SELECT DISTINCT class_code FROM aircraft WHERE aircraft.class_code IS NOT NULL").each do |class_code|
        AircraftClass.find_or_create_by_code(class_code)
      end
    end
    
    process "Derive some average characteristics from Aircraft" do
      AircraftClass.find_each do |aircraft_class|
        %w{ m3 m2 m1 b }.each do |coefficient|
          aircraft_class."#{coefficient}" = AircraftFuelUseEquation.
            where("aircraft.class_code = '#{aircraft_class.code}'").
            weighted_average(:"#{coefficient}", :weighted_by => [:aircraft, :passengers])
        end
        aircraft_class.seats = aircraft_class.aircraft.weighted_average(:seats, :weighted_by => :passengers)
        aircraft_class.m3_units = 'kilograms_per_cubic_nautical_mile'
        aircraft_class.m2_units = 'kilograms_per_square_nautical_mile'
        aircraft_class.m1_units = 'kilograms_per_nautical_mile'
        aircraft_class.b_units  = 'kilograms'
        aircraft.save
      end
    end
    
    # FIXME TODO verify this
  end
end
