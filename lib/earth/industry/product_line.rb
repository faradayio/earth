class ProductLine < ActiveRecord::Base
  set_primary_key :ps_code
  
  has_many :industry_product_lines,         :foreign_key => 'ps_code'
  
  has_many :product_line_industry_products, :foreign_key => 'ps_code'
  has_many :industry_products, :through => :product_line_industry_products
  
  col :ps_code
  col :description, :type => :text
  col :broadline # FIXME TODO do we need this?
  col :parent    # FIXME TODO do we need this?
end