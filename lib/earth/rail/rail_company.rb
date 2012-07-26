require 'earth/fuel'
require 'earth/locality'
class RailCompany < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "rail_companies"
  (
     "name"                        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "country_iso_3166_code"       CHARACTER VARYING(255),
     "duns_number"                 CHARACTER VARYING(255),
     "passengers"                  FLOAT,
     "passenger_distance"          FLOAT,
     "passenger_distance_units"    CHARACTER VARYING(255),
     "trip_distance"               FLOAT,
     "trip_distance_units"         CHARACTER VARYING(255),
     "train_distance"              FLOAT,
     "train_distance_units"        CHARACTER VARYING(255),
     "train_time"                  FLOAT,
     "train_time_units"            CHARACTER VARYING(255),
     "speed"                       FLOAT,
     "speed_units"                 CHARACTER VARYING(255),
     "electricity_intensity"       FLOAT,
     "electricity_intensity_units" CHARACTER VARYING(255),
     "diesel_intensity"            FLOAT,
     "diesel_intensity_units"      CHARACTER VARYING(255),
     "co2_emission_factor"         FLOAT,
     "co2_emission_factor_units"   CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code'
  

  warn_if_nulls_except(
    :duns_number,
    :train_time,
    :train_time_units,
    :speed,
    :speed_units,
    :electricity_intensity,
    :electricity_intensity_units,
    :diesel_intensity,
    :diesel_intensity_units,
    :co2_emission_factor,
    :co2_emission_factor_units
  )

  warn_unless_size 97
end
