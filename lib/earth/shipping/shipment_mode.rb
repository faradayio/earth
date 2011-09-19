class ShipmentMode < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'mode_name', :primary_key => 'name'
  
  col :name
  col :route_inefficiency_factor, :type => :float
  col :transport_emission_factor, :type => :float
  col :transport_emission_factor_units
end