class ProductLineIndustryProduct < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :product_line,     :foreign_key => 'ps_code'
  belongs_to :industry_product, :foreign_key => 'naics_product_code'

  force_schema do
    string 'row_hash'
    string 'ps_code'
    float  'ratio'
    string 'naics_product_code'
  end
end
