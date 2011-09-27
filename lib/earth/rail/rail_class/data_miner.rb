RailClass.class_eval do
  data_miner do
    process "Define some unit conversions" do
      Conversions.register :gallons_per_mile, :litres_per_kilometre, 2.35214583
    end
    
    import "a list of rail classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRYaDNvRXMtZGoxNmRiOHlNWGV6b2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'description'
      store 'passengers'
      store 'distance', :units_field_name => 'distance_units'
      store 'speed', :units_field_name => 'speed_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
    end
  end
end
