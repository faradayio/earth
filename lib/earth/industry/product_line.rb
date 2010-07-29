class ProductLine < ActiveRecord::Base
  set_primary_key :ps_code
  
  has_many :product_lines_sectors, :foreign_key => 'ps_code'
  has_many :sectors, :through => :product_lines_sectors
  
  data_miner do
    tap "Brighter Planet's product line data", Earth.taps_server
  end
end
