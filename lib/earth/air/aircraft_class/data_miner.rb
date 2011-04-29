AircraftClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'code'
      string  'name'
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
    
    import "a list of Brighter Planet-defined aircraft classes",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGNBbHFibmxJUFprQkUwZHp6VU51Smc&output=csv' do
      key 'code', :field_name => 'aircraft_class_code'
      store 'name'
    end
    
    process "Derive some average aircraft chraracteristics from aircraft and fuel use equation" do
      AircraftClass.all.each do |aircraft_class|
        relevant_aircraft = Aircraft.where(:class_code => aircraft_class.code)
        
        AircraftFuelUseEquation.weighted_average_relation(:m3, :weighted_by => [:aircraft, :passengers])
      end
      
      %w{ m3 m2 m1 b seats }.each do |column|
        relation = AircraftFuelUseEquation.weighted_average_relation(column).where(conditional_relation)
        update_all "#{column} = (#{relation.to_sql})"
      end
      
      update_all "m3_units = 'kilograms_per_cubic_nautical_mile'"
      update_all "m2_units = 'kilograms_per_square_nautical_mile'"
      update_all "m1_units = 'kilograms_per_nautical_mile'"
      update_all "b_units  = 'kilograms'"
    end
    
    # FIXME TODO verify this
  end
end
