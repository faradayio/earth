class Sector < ActiveRecord::Base
  set_primary_key :io_code

  data_miner do
    schema Earth.database_options do
      string 'io_code'
      string 'description'
      float  'emission_factor'
      string 'emission_factor_units'
    end
  end
end
