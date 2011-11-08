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
  end
end
