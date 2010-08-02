class IndustriesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'
end
