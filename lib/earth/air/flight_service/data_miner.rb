FlightService.class_eval do
  data_miner do
    schema do
      string 'name'
      string 'bts_service_class_code'
    end
  
    process "derive from flight segments" do
      FlightSegment.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO flight_services(name, bts_service_class_code)
        SELECT flight_segments.service_class_id, flight_segments.bts_service_class_code FROM flight_segments WHERE LENGTH(flight_segments.service_class_id) > 0
      }
    end
  end
end
