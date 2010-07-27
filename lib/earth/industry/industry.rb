class Industry < ActiveRecord::Base
  set_primary_key :naics_code
  
  has_many :merchant_categories, :through => :merchant_categories_industries
  
  data_miner do
    tap "Brighter Planet's industry data", Earth.taps_server
  end
end
