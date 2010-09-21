class IndustriesProductLines < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :row_hash
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'ps_code'

  def self.schema_definition
    lambda do
      string 'row_hash'
      string 'naics_code'
      float  'ratio'
      string 'ps_code'
      float  'revenue_allocated'
    end
  end

  data_miner do
    IndustriesProductLines.define_schema(self)
  end
end
