class Industry < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :naics_code
  
  has_many :merchant_category_industries, :foreign_key => 'naics_code'
  
  has_many :industry_product_lines, :foreign_key => 'naics_code'
  has_many :product_lines, :through => :industry_product_lines
  
  has_many :industry_sectors, :foreign_key => 'naics_code'
  has_many :sectors, :through => :industry_sectors
  
  def self.schema_definition
    lambda do
      string 'naics_code'
      string 'description'
    end
  end

  data_miner do
    Industry.define_schema(self)
  end
end
