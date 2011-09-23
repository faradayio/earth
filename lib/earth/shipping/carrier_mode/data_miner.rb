CarrierMode.class_eval do
  data_miner do
    import "a list of carrier modes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRsRkJOd0NPd0FETTI0NmpYUlBsN2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'carrier_name'
      store 'mode_name'
      store 'package_volume'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
  end
end
