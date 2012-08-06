require 'earth/model'
require 'falls_back_on'

require 'earth/shipping/carrier_mode'

class Carrier < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "carriers"
  (
     "name"                            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "full_name"                       CHARACTER VARYING(255),
     "package_volume"                  FLOAT,
     "route_inefficiency_factor"       FLOAT,
     "transport_emission_factor"       FLOAT,
     "transport_emission_factor_units" CHARACTER VARYING(255),
     "corporate_emission_factor"       FLOAT,
     "corporate_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :carrier_modes, :foreign_key => 'carrier_name', :primary_key => 'name'
  
  # TODO calculate these
  falls_back_on :route_inefficiency_factor => 1.03,
                :transport_emission_factor => 0.0005266,
                :corporate_emission_factor => 0.221
  
  warn_unless_size 3
end
