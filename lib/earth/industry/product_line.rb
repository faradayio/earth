class ProductLine < ActiveRecord::Base
  set_primary_key :pscode
  
  has_many :industries, :through => :industries_product_lines
  
  data_miner do
    tap "Brighter Planet's product line data", TAPS_SERVER
  end
end
