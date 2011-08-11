AircraftClass.class_eval do
  def self.update_averages!
    find_each do |aircraft_class|
      cumulative_passengers = 0
      aircraft_class.m3 = 0
      aircraft_class.m2 = 0
      aircraft_class.m1 = 0
      aircraft_class.b = 0
      
      aircraft_class.aircraft.where('passengers > 0 AND fuel_use_code IS NOT NULL').each do |a|
        cumulative_passengers += a.passengers
        aircraft_class.m3 += a.fuel_use_equation.m3 * a.passengers
        aircraft_class.m2 += a.fuel_use_equation.m2 * a.passengers
        aircraft_class.m1 += a.fuel_use_equation.m1 * a.passengers
        aircraft_class.b += a.fuel_use_equation.b * a.passengers
      end
      
      if cumulative_passengers > 0
        aircraft_class.m3 /= cumulative_passengers
        aircraft_class.m2 /= cumulative_passengers
        aircraft_class.m1 /= cumulative_passengers
        aircraft_class.b /= cumulative_passengers
      end
      
      aircraft_class.seats = aircraft_class.aircraft.weighted_average(:seats, :weighted_by => :passengers)
      
      aircraft_class.m3_units = 'kilograms_per_cubic_nautical_mile'
      aircraft_class.m2_units = 'kilograms_per_square_nautical_mile'
      aircraft_class.m1_units = 'kilograms_per_nautical_mile'
      aircraft_class.b_units  = 'kilograms'
      
      aircraft_class.save
    end
  end
  
  data_miner do
    process "Ensure Aircraft is populated" do
      Aircraft.run_data_miner!
    end
    
    process "Derive aircraft classes from Aircraft" do
      connection.select_values("SELECT DISTINCT class_code FROM aircraft WHERE aircraft.class_code IS NOT NULL").each do |class_code|
        AircraftClass.find_or_create_by_code(class_code)
      end
    end
    
    process :update_averages!
    
    # FIXME TODO verify this
  end
end
