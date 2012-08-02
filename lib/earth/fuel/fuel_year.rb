require 'earth/model'

require 'earth/fuel/fuel'

class FuelYear < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "fuel_years"
  (
     "name"                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "fuel_name"                          CHARACTER VARYING(255),
     "year"                               INTEGER,
     "energy_content"                     FLOAT,
     "energy_content_units"               CHARACTER VARYING(255),
     "carbon_content"                     FLOAT,
     "carbon_content_units"               CHARACTER VARYING(255),
     "oxidation_factor"                   FLOAT,
     "biogenic_fraction"                  FLOAT,
     "co2_emission_factor"                FLOAT,
     "co2_emission_factor_units"          CHARACTER VARYING(255),
     "co2_biogenic_emission_factor"       FLOAT,
     "co2_biogenic_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  
  warn_unless_size 171
end
