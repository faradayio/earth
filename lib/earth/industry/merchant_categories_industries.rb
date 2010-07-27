class MerchantCategoriesIndustries < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'
  
  data_miner do
    tap "Brighter Planet's merchant category to industry dictionary", Earth.taps_server
  end
end
