AircraftClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'aircraft_class_code'
      string  'name'
      float   'm1'
      float   'm2'
      float   'm3'
      float   'endpoint_fuel'
      integer 'seats'
    end
    
    import "Brighter Planet's aircraft classes",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGNBbHFibmxJUFprQkUwZHp6VU51Smc&hl=en&single=true&gid=0&output=csv' do
      key 'aircraft_class_code'
      store 'name'
    end
    
    process "Derive some average aircraft chraracteristics from aircraft" do
      Aircraft.run_data_miner!
      aircraft = Aircraft.arel_table
      aircraft_classes = AircraftClass.arel_table
      conditional_relation = aircraft_classes[:aircraft_class_code].eq(aircraft[:aircraft_class_code])
      
      %w{ m1 m2 m3 endpoint_fuel seats }.each do |column|
        relation = Aircraft.weighted_average_relation(column).where(conditional_relation)
        update_all "#{column} = (#{relation.to_sql})"
      end
    end
  end
end
