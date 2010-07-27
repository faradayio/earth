class IndustriesProductLines < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'pscode'
  
  data_miner do
    tap "Brighter Planet's industry to product line dictionary", TAPS_SERVER
  end
end
