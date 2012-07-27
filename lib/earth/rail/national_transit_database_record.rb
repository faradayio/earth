require 'earth/model'

require 'earth/rail/national_transit_database_company'
require 'earth/rail/national_transit_database_mode'

class NationalTransitDatabaseRecord < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "ntd_records"
  (
     "name"                     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "company_id"               CHARACTER VARYING(255),
     "mode_code"                CHARACTER VARYING(255),
     "service_type"             CHARACTER VARYING(255),
     "vehicle_distance"         FLOAT,
     "vehicle_distance_units"   CHARACTER VARYING(255),
     "vehicle_time"             FLOAT,
     "vehicle_time_units"       CHARACTER VARYING(255),
     "passenger_distance"       FLOAT,
     "passenger_distance_units" CHARACTER VARYING(255),
     "passengers"               FLOAT,
     "electricity"              FLOAT,
     "electricity_units"        CHARACTER VARYING(255),
     "diesel"                   FLOAT,
     "diesel_units"             CHARACTER VARYING(255),
     "gasoline"                 FLOAT,
     "gasoline_units"           CHARACTER VARYING(255),
     "lpg"                      FLOAT,
     "lpg_units"                CHARACTER VARYING(255),
     "lng"                      FLOAT,
     "lng_units"                CHARACTER VARYING(255),
     "cng"                      FLOAT,
     "cng_units"                CHARACTER VARYING(255),
     "kerosene"                 FLOAT,
     "kerosene_units"           CHARACTER VARYING(255),
     "biodiesel"                FLOAT,
     "biodiesel_units"          CHARACTER VARYING(255),
     "other_fuel"               FLOAT,
     "other_fuel_units"         CHARACTER VARYING(255),
     "other_fuel_description"   CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  self.table_name = :ntd_records
  
  belongs_to :ntd_company, :foreign_key => 'company_id', :class_name => 'NationalTransitDatabaseCompany'
  
  def self.rail_records
    where(:mode_code => NationalTransitDatabaseMode.rail_modes)
  end
  

  warn_if_nulls_except(
    :passenger_distance,
    :passenger_distance_units,
    :electricity,
    :electricity_units,
    :diesel,
    :diesel_units,
    :gasoline,
    :gasoline_units,
    :lpg,
    :lpg_units,
    :lng,
    :lng_units,
    :cng,
    :cng_units,
    :kerosene,
    :kerosene_units,
    :biodiesel,
    :biodiesel_units,
    :other_fuel,
    :other_fuel_units,
    :other_fuel_description
  )

  warn_unless_size 1310
end
