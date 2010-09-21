FlightPropulsion.class_eval do
  data_miner do
    schema do
      string 'name'
      string 'bts_aircraft_group_code'
    end
    
    process "derive from flight segments" do
      FlightSegment.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO flight_propulsions(name, bts_aircraft_group_code)
        SELECT flight_segments.propulsion_id, flight_segments.bts_aircraft_group_code FROM flight_segments WHERE LENGTH(flight_segments.propulsion_id) > 0
      }
    end
  end
end
