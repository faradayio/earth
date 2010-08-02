class ProductLinesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :product_line, :foreign_key => 'ps_code'
  belongs_to :sector,       :foreign_key => 'io_code'

  data_miner do
    schema Earth.database_options do
      string 'row_hash'
      string 'ps_code'
      float  'ratio'
      string 'io_code'
    end
  end
end
