class ProductLine < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :ps_code
  
  has_many :industry_product_lines,         :foreign_key => 'ps_code'
  
  has_many :product_line_industry_products, :foreign_key => 'ps_code'
  has_many :industry_products, :through => :product_line_industry_products
  
  def self.schema_definition
    lambda do
      string 'ps_code'
      string 'description'
      string 'broadline' # FIXME TODO do we need this?
      string 'parent'    # FIXME TODO do we need this?
    end
  end

  data_miner do
    ProductLine.define_schema(self)
  end
end
