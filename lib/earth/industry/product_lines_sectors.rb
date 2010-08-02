class ProductLinesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :product_line, :foreign_key => 'ps_code'
  belongs_to :sector,       :foreign_key => 'io_code'
end
