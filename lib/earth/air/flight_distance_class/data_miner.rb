FlightDistanceClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
    end
    
    import "a list of distance classes taken from the WRI business travel tool and UK DEFRA/DECC GHG Conversion Factors for Company Reporting",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFBKM0xWaUhKVkxDRmdBVkE3VklxY2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
    end
    
    # FIXME TODO verify this
  end
end
