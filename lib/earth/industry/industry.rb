class Industry < ActiveRecord::Base
  set_primary_key :naics_code
  
  has_many :merchant_category_industries, :foreign_key => 'naics_code'
  
  has_many :industry_product_lines, :foreign_key => 'naics_code'
  has_many :product_lines, :through => :industry_product_lines
  
  has_many :industry_sectors, :foreign_key => 'naics_code'
  has_many :sectors, :through => :industry_sectors
  
  force_schema do
    string 'naics_code'
    string 'description'
  end

  def trade_industry?
    prefix = naics_code.to_s[0,2]
    %w{42 44 45}.include?(prefix)
  end
end
