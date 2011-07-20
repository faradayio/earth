class CarrierMode < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'

  force_schema do
    string 'name'
    string 'carrier_name'
    string 'mode_name'
    float  'package_volume'
    float  'route_inefficiency_factor'
    float  'transport_emission_factor'
    string 'transport_emission_factor_units'
  end
end
