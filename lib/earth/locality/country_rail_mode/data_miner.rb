CountryRailMode.class_eval do
  data_miner do
    import "a list of country-specific rail classes and their pre-calculated characteristics",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFg3YVptS2FYdHBsb2kyZFRxSm5FdlE&output=csv' do
      key   'name'
      store 'country_iso_3166_code'
      store 'rail_mode_name'
      store 'speed',                 :units_field_name => 'speed_units'
      store 'trip_distance',         :units_field_name => 'trip_distance_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity',      :units_field_name => 'diesel_intensity_units'
      store 'emission_factor',       :units_field_name => 'emission_factor_units'
    end
  end
end
