class Industry < ActiveRecord::Base
  set_primary_key :naics_code
  
  has_many :merchant_category_industries, :foreign_key => 'naics_code'
  
  has_many :industry_product_lines, :foreign_key => 'naics_code'
  has_many :product_lines, :through => :industry_product_lines
  
  has_many :industry_sectors, :foreign_key => 'naics_code'
  has_many :sectors, :through => :industry_sectors
  
  col :naics_code
  col :description, :type => :text
  
  data_miner do
    import "the U.S. Census 2002 NAICS code list",
           :url => 'http://www.census.gov/epcd/naics02/naicod02.txt',
           :skip => 4,
           :headers => false,
           :delimiter => '	' do
      key 'naics_code', :field_number => 0
      store 'description', :field_number => 1
    end
  end

  def trade_industry?
    prefix = naics_code.to_s[0,2]
    %w{42 44 45}.include?(prefix)
  end
end
