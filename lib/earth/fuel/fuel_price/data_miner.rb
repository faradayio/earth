FuelPrice.class_eval do
  # FIXME TODO phase 2
  # location
  # month/year

  data_miner do
    import 'fuel prices derived from the EIA',
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHlSdXJoOFB5aEpHenJQbTVJdS1pMVE&gid=0&output=csv',
           :select => proc { |row| row['fuel_type_name'].present? } do
      key   'name', :field_name => 'fuel_type_name'
      store 'price', :units_field_name => 'price_units'
    end
  end
end
