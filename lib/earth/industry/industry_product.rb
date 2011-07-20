class IndustryProduct < ActiveRecord::Base
  set_primary_key :naics_product_code
  
  has_many :product_line_industry_products, :foreign_key => 'naics_product_code'
  
  belongs_to :industry, :foreign_key => 'naics_code'
  
  force_schema do
    string 'naics_product_code'
    string 'description'
    float  'value'
    string 'value_units'
    string 'naics_code'
  end
end
