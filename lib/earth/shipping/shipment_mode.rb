class ShipmentMode < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's shipment mode data", Earth.taps_server
  end
end
