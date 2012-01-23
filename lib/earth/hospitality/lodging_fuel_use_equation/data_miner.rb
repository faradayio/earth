LodgingFuelUseEquation.class_eval do
  data_miner do
    import "fuel use equations derived from CBECS 2003",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGN0X2l3RjFaRTBFRWdseWJoc0ZvZkE&output=csv' do
      key 'name'
      store 'regression'
      store 'fuel'
      store 'climate_zone_number', :nullify => true
      store 'property_rooms'
      store 'construction_year'
      store 'rooms_factor'
      store 'year_factor'
      store 'constant'
      store 'units'
      store 'oil_share'
      store 'gas_share'
      store 'steam_share'
    end
  end
end
