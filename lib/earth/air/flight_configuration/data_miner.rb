FlightConfiguration.class_eval do
  data_miner do
    schema do
      string 'name'
      string 'bts_aircraft_configuration_code'
    end

    process "derive from flight segments" do
      FlightSegment.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO flight_configurations(name, bts_aircraft_configuration_code)
        SELECT flight_segments.configuration_id, flight_segments.bts_aircraft_configuration_code FROM flight_segments WHERE LENGTH(flight_segments.configuration_id) > 0
      }
    end
  end
end
