class MerchantCategoryIndustry < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'

  force_schema do
    string 'row_hash'
    string 'mcc'
    float  'ratio'
    string 'naics_code'
  end
end
