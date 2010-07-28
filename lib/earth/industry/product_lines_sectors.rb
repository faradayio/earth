class ProductLinesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :product_line, :foreign_key => 'pscode'
  belongs_to :sector,       :foreign_key => 'io_code'
  
  data_miner do
    tap "Brighter Planet's product line to input-output sector dictionary", Earth.taps_server
  end
end
