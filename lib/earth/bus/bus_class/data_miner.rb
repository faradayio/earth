BusClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
      float  'passengers'
      float  'speed'
      string 'speed_units'
      float  'diesel_intensity'
      string 'diesel_intensity_units'
      float  'alternative_fuels_intensity'
      string 'alternative_fuels_intensity_units'
      float  'air_conditioning_emission_factor'
      string 'air_conditioning_emission_factor_units'
    end
    
    import "a list of bus classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRsSnJoS1hraGJvR012cDROWXFPbVE&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
      store 'passengers'
      store 'speed', :units_field_name => 'speed_units'
      store 'diesel_intensity', :units_field_name => 'diesel_intensity_units'
      store 'alternative_fuels_intensity', :units_field_name => 'alternative_fuels_intensity_units'
      store 'air_conditioning_emission_factor', :units_field_name => 'air_conditioning_emission_factor_units'
    end
  end
end
