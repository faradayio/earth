require 'earth/model'

require 'earth/shipping/carrier'
require 'earth/shipping/shipment_mode'

class CarrierMode < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE carrier_modes
  (
     name                            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     carrier_name                    CHARACTER VARYING(255),
     mode_name                       CHARACTER VARYING(255),
     package_volume                  FLOAT,
     route_inefficiency_factor       FLOAT,
     transport_emission_factor       FLOAT,
     transport_emission_factor_units CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'

  warn_unless_size 9
end
