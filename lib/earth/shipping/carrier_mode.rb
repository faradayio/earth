class CarrierMode < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'

  col :name
  col :carrier_name
  col :mode_name
  col :package_volume, :type => :float
  col :route_inefficiency_factor, :type => :float
  col :transport_emission_factor, :type => :float
  col :transport_emission_factor_units
end