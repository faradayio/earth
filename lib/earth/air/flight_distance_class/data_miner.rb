FlightDistanceClass.class_eval do
  data_miner do
    import "distance classes from the WRI business travel tool and UK DEFRA/DECC GHG Conversion Factors for Company Reporting",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFBKM0xWaUhKVkxDRmdBVkE3VklxY2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'distance',     :units_field_name => 'distance_units'
      store 'min_distance', :units_field_name => 'min_distance_units', :nullify => true
      store 'max_distance', :units_field_name => 'max_distance_units', :nullify => true
    end
    
    # FIXME TODO verify that min_distance >= 0
    # FIXME TODO verify that max_distance > 0
    # FIXME TODO verify that distance class distance bounds don't overlap
    
    process "Ensure FlightSegment is populated" do
      FlightSegment.run_data_miner!
    end
    
    process "Calculate passengers for each distance class" do
      find_each do |distance_class|
        distance_class.passengers = FlightSegment.distances_between(distance_class.min_distance, distance_class.max_distance).sum(:passengers)
        distance_class.save!
      end
    end
    
    # FIXME TODO verify this
  end
end
