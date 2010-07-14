class AircraftManufacturer < ActiveRecord::Base
  set_primary_key :name
  
  has_many :aircraft, :foreign_key => 'manufacturer_name'
  
  data_miner do
    tap "Brighter Planet's aircraft manufacturer data", TAPS_SERVER
  end
end
