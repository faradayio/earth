FlightSeatClass.class_eval do
  data_miner do
    process "Ensure that FlightDistanceClassSeatClass is populated" do
      FlightDistanceClassSeatClass.run_data_miner!
    end
    
    process "Derive flight seat classes names from FlightDistanceClassSeatClass" do
      connection.select_values("SELECT DISTINCT seat_class_name FROM #{FlightDistanceClassSeatClass.quoted_table_name}").each do |seat_class_name|
        find_or_create_by_name seat_class_name
      end
    end
    
    process "Calculate multipliers from FlightDistanceClassSeatClass and FlightDistanceClass" do
      find_each do |seat_class|
        seat_class.multiplier = seat_class.distance_class_seat_classes.weighted_average(:multiplier, :weighted_by => [:distance_class, :passengers])
        seat_class.save!
      end
    end
  end
end
