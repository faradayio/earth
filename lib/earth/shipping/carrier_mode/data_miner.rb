CarrierMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'carrier_name'
      string 'mode_name'
      boolean 'include_in_fallbacks'
      float  'package_volume'
      float  'route_inefficiency_factor'
      float  'transport_emission_factor'
      string 'transport_emission_factor_units'
    end
    
    import "a list of carrier modes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRsRkJOd0NPd0FETTI0NmpYUlBsN2c&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'carrier_name'
      store 'mode_name'
      store 'include_in_fallbacks'
      store 'package_volume'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
    
    # TODO: verification
    # all entries should have carrier_name
    # all entries should have mode_name
    # all entries should have include_in_fallbacks
    # all entries should have package_volume
    # all entries should have route_inefficiency_factor
    # all entries should have transport emission factor > 0
    # all entries should have transport emission factor units
  end
end
