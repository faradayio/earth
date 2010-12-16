class CarrierMode < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'
  
  data_miner do
    tap "Brighter Planet's carrier mode data", Earth.taps_server
  end
end
