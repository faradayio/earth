class ProductLineIndustryProduct < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :row_hash
  
  belongs_to :product_line,     :foreign_key => 'ps_code'
  belongs_to :industry_product, :foreign_key => 'naics_product_code'

  def self.schema_definition
    lambda do
      string 'row_hash'
      string 'ps_code'
      float  'ratio'
      string 'naics_product_code'
    end
  end

  data_miner do
    ProductLineIndustryProduct.define_schema(self)
  end
end
