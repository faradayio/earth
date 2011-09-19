class MerchantCategoryIndustry < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'

  col :row_hash
  col :mcc
  col :ratio, :type => :float
  col :naics_code
end