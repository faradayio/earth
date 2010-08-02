class IndustriesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

  data_miner do
    schema Earth.database_options do
      string 'row_hash'
      string 'naics_code'
      float  'ratio'
      string 'io_code'
    end
  end
end
