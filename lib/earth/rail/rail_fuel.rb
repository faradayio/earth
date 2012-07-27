require 'earth/model'
require 'earth/fuel'
class RailFuel < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "rail_fuels"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "fuel_name"                 CHARACTER VARYING(255),
     "ch4_emission_factor"       FLOAT,
     "ch4_emission_factor_units" CHARACTER VARYING(255),
     "n2o_emission_factor"       FLOAT,
     "n2o_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  
  delegate :density, :density_units, :co2_emission_factor, :co2_emission_factor_units, :co2_biogenic_emission_factor, :co2_biogenic_emission_factor_units, :to => :fuel, :allow_nil => true
  

  warn_unless_size 1
end
