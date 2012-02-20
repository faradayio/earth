require 'earth/locality'

# TODO replace this with NAICS 2002?
class Industry < ActiveRecord::Base
  self.primary_key = "naics_code"
  
  has_many :merchant_category_industries, :foreign_key => 'naics_code'
  
  has_many :industry_product_lines, :foreign_key => 'naics_code'
  has_many :product_lines, :through => :industry_product_lines
  
  has_many :industry_sectors, :foreign_key => 'naics_code'
  has_many :sectors, :through => :industry_sectors
  
  col :naics_code
  col :description
  
  class << self
    def format_naics_code(input)
      "%d" % input.to_i
    end
  end
end
