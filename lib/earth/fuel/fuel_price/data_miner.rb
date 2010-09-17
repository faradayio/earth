FuelPrice.class_eval do
  # FIXME TODO phase 2
  # location
  # month/year

  data_miner do
    schema Earth.database_options do
      string  'name'
      float   'price'
      string  'price_units'
    end
    
    import 'fuel prices derived from the EIA',
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHlSdXJoOFB5aEpHenJQbTVJdS1pMVE',
           :select => lambda { |row| row['fuel_type_name'].present? } do
      key   'name', :field_name => 'fuel_type_name'
      store 'price', :units_field_name => 'price_units'
    end
  end
end
