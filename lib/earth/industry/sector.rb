class Sector < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :io_code

  def self.schema_definition
    lambda do
      string 'io_code'
      string 'description'
      float  'value'
      string 'value_units'
    end
  end

  data_miner do
    Sector.define_schema(self)
  end
end
