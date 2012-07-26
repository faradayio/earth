class CommercialBuildingEnergyConsumptionSurveyResponse < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "cbecs_responses"
  (
     "id"                                 INTEGER NOT NULL,
     "census_region_number"               INTEGER,
     "census_division_number"             INTEGER,
     "climate_zone_number"                INTEGER,
     "heating_degree_days"                FLOAT,
     "heating_degree_days_units"          CHARACTER VARYING(255),
     "cooling_degree_days"                FLOAT,
     "cooling_degree_days_units"          CHARACTER VARYING(255),
     "construction_year"                  INTEGER,
     "area"                               FLOAT,
     "area_units"                         CHARACTER VARYING(255),
     "floors"                             INTEGER,
     "lodging_rooms"                      INTEGER,
     "percent_cooled"                     FLOAT,
     "food_prep_room"                     BOOLEAN,
     "laundry_onsite"                     BOOLEAN,
     "indoor_pool"                        BOOLEAN,
     "principal_activity"                 CHARACTER VARYING(255),
     "detailed_activity"                  CHARACTER VARYING(255),
     "first_activity"                     CHARACTER VARYING(255),
     "second_activity"                    CHARACTER VARYING(255),
     "third_activity"                     CHARACTER VARYING(255),
     "first_activity_share"               FLOAT,
     "second_activity_share"              FLOAT,
     "third_activity_share"               FLOAT,
     "months_used"                        INTEGER,
     "weekly_hours"                       INTEGER,
     "electricity_use"                    FLOAT,
     "electricity_use_units"              CHARACTER VARYING(255),
     "electricity_energy"                 FLOAT,
     "electricity_energy_units"           CHARACTER VARYING(255),
     "natural_gas_use"                    FLOAT,
     "natural_gas_use_units"              CHARACTER VARYING(255),
     "natural_gas_energy"                 FLOAT,
     "natural_gas_energy_units"           CHARACTER VARYING(255),
     "fuel_oil_use"                       FLOAT,
     "fuel_oil_use_units"                 CHARACTER VARYING(255),
     "fuel_oil_energy"                    FLOAT,
     "fuel_oil_energy_units"              CHARACTER VARYING(255),
     "district_heat_use"                  FLOAT,
     "district_heat_use_units"            CHARACTER VARYING(255),
     "district_heat_energy"               FLOAT,
     "district_heat_energy_units"         CHARACTER VARYING(255),
     "stratum"                            INTEGER,
     "pair"                               INTEGER,
     "weighting"                          FLOAT,
     "room_nights"                        FLOAT,
     /* what follow are for lodging fuzzy weighting */
     "electricity_per_room_night"         FLOAT,
     "electricity_per_room_night_units"   CHARACTER VARYING(255),
     "natural_gas_per_room_night"         FLOAT,
     "natural_gas_per_room_night_units"   CHARACTER VARYING(255),
     "fuel_oil_per_room_night"            FLOAT,
     "fuel_oil_per_room_night_units"      CHARACTER VARYING(255),
     "district_heat_per_room_night"       FLOAT,
     "district_heat_per_room_night_units" CHARACTER VARYING(255)
  );
ALTER TABLE "cbecs_responses" ADD PRIMARY KEY ("id")
EOS

  self.primary_key = "id"
  self.table_name = :cbecs_responses
  
  def self.lodging_records
    where(:detailed_activity => ['Hotel', 'Motel or inn'], :first_activity => nil)
  end
end
