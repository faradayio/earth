class AutomobileTypeFuelControl < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_type_fuel_controls"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "type_name"                 CHARACTER VARYING(255),
     "fuel_family"               CHARACTER VARYING(255),
     "control_name"              CHARACTER VARYING(255),
     "ch4_emission_factor"       FLOAT,
     "ch4_emission_factor_units" CHARACTER VARYING(255),
     "n2o_emission_factor"       FLOAT,
     "n2o_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"

  
  warn_unless_size 20
end
