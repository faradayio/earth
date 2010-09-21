class ProductLineSector < ActiveRecord::Base
  extend Earth::Base
  belongs_to :product_line, :foreign_key => 'ps_code'
  belongs_to :sector,       :foreign_key => 'io_code'

  def self.schema_definition
    lambda do
      string 'row_hash'
      string 'ps_code'
      float  'ratio'
      string 'io_code'
    end
  end

  data_miner do
    ProductLineSector.define_schema(self)
  end
end
