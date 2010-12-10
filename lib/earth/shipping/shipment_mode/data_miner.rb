ShipmentMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'route_inefficiency_factor'
      float  'transport_emission_factor'
      string 'transport_emission_factor_units'
    end
    
    import "a list of shipment modes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGR2a2RYcEg2RnRKbkRQcXc0ZkQ5U0E&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
  end
end
