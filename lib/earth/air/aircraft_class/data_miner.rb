AircraftClass.class_eval do
  data_miner do
    process "Derive aircraft classes from Aircraft" do
      Aircraft.run_data_miner!
      connection.select_values("SELECT DISTINCT class_code FROM aircraft WHERE class_code IS NOT NULL").each do |class_code|
        AircraftClass.find_or_create_by_code(class_code)
      end
    end
    
    process :update_averages!
    
    # FIXME TODO verify this
  end
end
