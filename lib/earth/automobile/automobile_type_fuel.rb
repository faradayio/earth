class AutomobileTypeFuel < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_type_fuels"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL,
     "type_name"                 CHARACTER VARYING(255),
     "fuel_family"               CHARACTER VARYING(255),
     "annual_distance"           FLOAT,
     "annual_distance_units"     CHARACTER VARYING(255),
     "fuel_consumption"          FLOAT,
     "fuel_consumption_units"    CHARACTER VARYING(255),
     "ch4_emission_factor"       FLOAT,
     "ch4_emission_factor_units" CHARACTER VARYING(255),
     "n2o_emission_factor"       FLOAT,
     "n2o_emission_factor_units" CHARACTER VARYING(255),
     "vehicles"                  FLOAT
  );
ALTER TABLE "automobile_type_fuels" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  # for calculating vehicles
  def latest_activity_year_type_fuel
    AutomobileActivityYearTypeFuel.latest.where(:type_name => type_name, :fuel_family => fuel_family).first
  end
  
  
  warn_unless_size 4
end
