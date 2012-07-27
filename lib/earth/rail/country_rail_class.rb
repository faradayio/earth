require 'earth/model'
require 'earth/locality'
class CountryRailClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "country_rail_classes"
  (
     "name"                        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "country_iso_3166_code"       CHARACTER VARYING(255),
     "rail_class_name"             CHARACTER VARYING(255),
     "passengers"                  FLOAT,
     "speed"                       FLOAT,
     "speed_units"                 CHARACTER VARYING(255),
     "trip_distance"               FLOAT,
     "trip_distance_units"         CHARACTER VARYING(255),
     "electricity_intensity"       FLOAT,
     "electricity_intensity_units" CHARACTER VARYING(255),
     "diesel_intensity"            FLOAT,
     "diesel_intensity_units"      CHARACTER VARYING(255),
     "co2_emission_factor"         FLOAT,
     "co2_emission_factor_units"   CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  

  warn_unless_size 4
end
