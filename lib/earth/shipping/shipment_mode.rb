require 'earth/model'

require 'earth/shipping/carrier_mode'

class ShipmentMode < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE shipment_modes
  (
     name                            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     route_inefficiency_factor       FLOAT,
     transport_emission_factor       FLOAT,
     transport_emission_factor_units CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  has_many :carrier_modes, :foreign_key => 'mode_name', :primary_key => 'name'
  
  warn_unless_size 3
end
