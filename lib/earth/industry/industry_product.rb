require 'earth/locality'
class IndustryProduct < ActiveRecord::Base
  self.primary_key = :naics_product_code
  
  has_many :product_line_industry_products, :foreign_key => 'naics_product_code'
  
  belongs_to :industry, :foreign_key => 'naics_code'
  
  col :naics_product_code
  col :description, :type => :text
  col :value, :type => :float
  col :value_units
  col :naics_code
end
