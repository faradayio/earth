class IndustrySector < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :row_hash
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

  def self.schema_definition
    lambda do
      string 'row_hash'
      string 'naics_code'
      float  'ratio'
      string 'io_code'
    end
  end

  data_miner do
    IndustrySector.define_schema(self)
  end
end
