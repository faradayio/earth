AircraftClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'brighter_planet_aircraft_class_code'
      string  'name'
      float   'm1'
      float   'm2'
      float   'm3'
      float   'endpoint_fuel'
      integer 'seats'
    end
    
    import "Brighter Planet's aircraft classes", :url => 'http://static.brighterplanet.com/science/data/transport/air/brighter_planet_aircraft_classes.csv' do
      key 'brighter_planet_aircraft_class_code'
      store 'name', :field_name => 'description'
    end
    
    process "Derive some average aircraft chraracteristics from aircraft" do
      Aircraft.run_data_miner!
      aircraft = Aircraft.arel_table
      aircraft_classes = AircraftClass.arel_table
      conditional_relation = aircraft_classes[:brighter_planet_aircraft_class_code].eq(aircraft[:brighter_planet_aircraft_class_code])
      %w{ m1 m2 m3 endpoint_fuel }.each do |column|
        relation = Aircraft.weighted_average_relation(column).
                            where(conditional_relation)
        update_all "#{column} = (#{relation.to_sql})"
      end
    end
    
    process "Derive some average aircraft characteristics from flight segments" do # FIXME TODO why not derive this from aircraft?
      FlightSegment.run_data_miner!
      aircraft = Aircraft.arel_table
      aircraft_classes = AircraftClass.arel_table
      segments = FlightSegment.arel_table
      relation = FlightSegment.joins(:aircraft). # this requires associations
                               weighted_average_relation(:seats, :weighted_by => :passengers).
                               where(aircraft_classes[:brighter_planet_aircraft_class_code].eq(aircraft[:brighter_planet_aircraft_class_code]))
      update_all "seats = (#{relation.to_sql})"
    end
  end
end

