class ShipmentMode < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :route_inefficiency_factor => 1.05,#ShipmentMode.where(not(:name => 'courier')).average(:route_inefficiency_factor),
                :transport_emission_factor => 0.0007696#ShipmentMode.where(not(:name => 'courier')).average(:route_inefficiency_factor)
  
  data_miner do
    tap "Brighter Planet's shipment mode data", Earth.taps_server
  end
end
