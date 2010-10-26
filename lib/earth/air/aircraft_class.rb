class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  has_many :aircraft, :foreign_key => 'code', :primary_key => 'bp_code'
  
  data_miner do
    tap "Brighter Planet's aircraft class data", Earth.taps_server
  end
end
