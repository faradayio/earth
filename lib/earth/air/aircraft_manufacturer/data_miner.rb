AircraftManufacturer.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string 'name'
    end
    
    process "Derive a list of aircraft manufacturers from aircraft" do
      Aircraft.run_data_miner!
      INSERT_IGNORE %{INTO aircraft_manufacturers(name)
        SELECT aircraft.manufacturer_name FROM aircraft WHERE aircraft.manufacturer_name IS NOT NULL
      }
    end
  end
end
