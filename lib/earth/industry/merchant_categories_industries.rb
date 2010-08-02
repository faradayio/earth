class MerchantCategoriesIndustries < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'
  has_many :industries_product_lines, :through => :industry, :class_name => 'IndustriesProductLines'
  has_many :industries_sectors, :through => :industry, :class_name => 'IndustriesSectors'
end
