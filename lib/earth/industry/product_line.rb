class ProductLine < ActiveRecord::Base
  set_primary_key :pscode
  
  has_many :product_lines_sectors, :foreign_key => 'pscode'
  has_many :sectors, :through => :product_lines_sectors
  
  data_miner do
    tap "Brighter Planet's product line data", Earth.taps_server
  end
end
