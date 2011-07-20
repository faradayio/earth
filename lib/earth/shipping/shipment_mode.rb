class ShipmentMode < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'mode_name', :primary_key => 'name'
  
  force_schema do
    string 'name'
    float  'route_inefficiency_factor'
    float  'transport_emission_factor'
    string 'transport_emission_factor_units'
  end
end
