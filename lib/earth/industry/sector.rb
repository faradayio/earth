class Sector < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :io_code

  has_many :product_line_sectors, :foreign_key => 'io_code'

  def self.schema_definition
    lambda do
      string 'io_code'
      string 'description'
      float 'emission_factor'
      string 'emission_factor_units'
    end
  end

  data_miner do
    Sector.define_schema(self)
  end
end
