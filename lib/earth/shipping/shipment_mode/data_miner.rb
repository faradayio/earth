ShipmentMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'route_inefficiency_factor'
      float  'transport_emission_factor'
      string 'transport_emission_factor_units'
    end
  end
end
