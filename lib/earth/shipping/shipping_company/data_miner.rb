ShippingCompany.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'corporate_emission_factor'
      string 'corporate_emission_factor_units'
    end
  end
end
