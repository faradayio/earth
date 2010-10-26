class AircraftManufacturer < ActiveRecord::Base
  set_primary_key :name
  
  has_many :aircraft, :foreign_key => 'name'
  
  data_miner do
    tap "Brighter Planet's aircraft manufacturer data", Earth.taps_server
  end
end
