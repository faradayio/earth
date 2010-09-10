LodgingClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'emission_factor'
      string 'emission_factor_units'
    end
  end
end

