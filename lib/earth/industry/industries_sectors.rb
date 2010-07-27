class IndustriesSectors < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector, :foreign_key => 'io_code'
  
  data_miner do
    tap "Brighter Planet's industry to input-output sector dictionary", Earth.taps_server
  end
end
