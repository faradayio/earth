class IndustryProduct < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :naics_product_code
  
  has_many :product_line_industry_products, :foreign_key => 'naics_product_code'
  
  belongs_to :industry, :foreign_key => 'naics_code'
  
  def self.schema_definition
    lambda do
      string 'naics_product_code'
      string 'description'
      float  'value'
      string 'value_units'
      string 'naics_code'
    end
  end

  data_miner do
    IndustryProduct.define_schema(self)
  end
end
