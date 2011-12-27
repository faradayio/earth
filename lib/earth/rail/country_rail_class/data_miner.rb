require 'earth/locality/data_miner'
CountryRailClass.class_eval do
  data_miner do
    import "a list of country-specific rail classes and their pre-calculated characteristics",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFg3YVptS2FYdHBsb2kyZFRxSm5FdlE&output=csv' do
      key   'name', :synthesize => lambda { |record| [record['country_iso_3166_code'], record['rail_class_name']].join(' ') }
      store 'country_iso_3166_code'
      store 'rail_class_name'
      store 'passengers'
      store 'speed',                 :units_field_name => 'speed_units'
      store 'trip_distance',         :units_field_name => 'trip_distance_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity',      :units_field_name => 'diesel_intensity_units'
      store 'co2_emission_factor',   :units_field_name => 'co2_emission_factor_units'
    end
  end
end
