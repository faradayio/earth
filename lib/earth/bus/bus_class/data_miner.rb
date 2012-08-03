BusClass.class_eval do
  data_miner do
    import "a list of bus classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdGRsSnJoS1hraGJvR012cDROWXFPbVE&gid=0&output=csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
      store 'passengers'
      store 'speed', :units_field_name => 'speed_units'
      store 'gasoline_intensity', :units_field_name => 'gasoline_intensity_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
      store 'cng_intensity', :units_field_name => 'cng_intensity_units'
      store 'lng_intensity', :units_field_name => 'lng_intensity_units'
      store 'lpg_intensity', :units_field_name => 'lpg_intensity_units'
      store 'methanol_intensity', :units_field_name => 'methanol_intensity_units'
      store 'biodiesel_intensity', :units_field_name => 'biodiesel_intensity_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'air_conditioning_emission_factor', :units_field_name => 'air_conditioning_emission_factor_units'
    end
  end
end
