class ShipmentMode < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'mode_name', :primary_key => 'name'
  
  data_miner do
    tap "Brighter Planet's shipment mode data", Earth.taps_server
  end
end
