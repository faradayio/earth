class IndustriesSectors < Earth::Base
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

  def self.schema_definition
    lambda do
      string 'naics_code'
      float  'ratio'
      string 'io_code'
    end
  end

  data_miner do
    IndustriesSectors.define_schema(self)
  end
end
