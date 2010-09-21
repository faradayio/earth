class MerchantCategoriesIndustries < ActiveRecord::Base
  extend Earth::Base
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'
  has_many :industries_product_lines, :through => :industry, :class_name => 'IndustriesProductLines'
  has_many :industries_sectors, :through => :industry, :class_name => 'IndustriesSectors'

  def self.schema_definition
    lambda do
      string 'mcc'
      float  'ratio'
      string 'naics_code'
    end
  end

  data_miner do
    MerchantCategoriesIndustries.define_schema(self)
  end
end
