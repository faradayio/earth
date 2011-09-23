AutomobileSizeClassYear.class_eval do
  data_miner do
    import "automobile size class year fuel efficiencies from the 2010 EPA Fuel Economy Trends report",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDZOLWdDdlZja04xZkJYc3NjeGxQamc&hl=en&gid=0&output=csv' do
      key 'name'
      store 'size_class_name'
      store 'year'
      store 'type_name'
      store 'fuel_efficiency_city', :units_field_name => 'fuel_efficiency_city_units'
      store 'fuel_efficiency_highway', :units_field_name => 'fuel_efficiency_highway_units'
    end
    
    # FIXME TODO verify that size_class_name is never missing?
    # FIXME TODO verify that type_name appears in AutomobileTypeFuelYearAges
  end
end
