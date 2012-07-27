require 'earth/model'

require 'earth/fuel'
class BusFuelControl < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "bus_fuel_controls"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL,
     "bus_fuel_name"             CHARACTER VARYING(255),
     "control"                   CHARACTER VARYING(255),
     "ch4_emission_factor"       FLOAT,
     "ch4_emission_factor_units" CHARACTER VARYING(255),
     "n2o_emission_factor"       FLOAT,
     "n2o_emission_factor_units" CHARACTER VARYING(255)
  );
ALTER TABLE "bus_fuel_controls" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"

  warn_unless_size 9
end
