class AircraftClass < ActiveRecord::Base
  set_primary_key :code
  
  # has_many :aircraft, :foreign_key => 'class_code', :primary_key => 'code'
  
  data_miner do
    tap "Brighter Planet's aircraft class data", Earth.taps_server
  end
end
