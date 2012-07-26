require 'earth/fuel'
require 'earth/locality'
class CountryRailTractionClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "country_rail_traction_classes"
  (
     "name"                        CHARACTER VARYING(255) NOT NULL,
     "country_iso_3166_code"       CHARACTER VARYING(255),
     "rail_traction_name"          CHARACTER VARYING(255),
     "rail_class_name"             CHARACTER VARYING(255),
     "electricity_intensity"       FLOAT,
     "electricity_intensity_units" CHARACTER VARYING(255),
     "diesel_intensity"            FLOAT,
     "diesel_intensity_units"      CHARACTER VARYING(255),
     "co2_emission_factor"         FLOAT,
     "co2_emission_factor_units"   CHARACTER VARYING(255)
  );
ALTER TABLE "country_rail_traction_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  

  warn_unless_size 125
end
