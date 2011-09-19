class ProductLineIndustryProduct < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :product_line,     :foreign_key => 'ps_code'
  belongs_to :industry_product, :foreign_key => 'naics_product_code'

  col :row_hash
  col :ps_code
  col :ratio, :type => :float
  col :naics_product_code
end