require 'earth/model'

class AutomobileTypeFuelYear < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_type_fuel_years"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL,
     "type_name"                 CHARACTER VARYING(255),
     "fuel_family"               CHARACTER VARYING(255),
     "year"                      INTEGER,
     "share_of_type"             FLOAT,
     "annual_distance"           FLOAT,
     "annual_distance_units"     CHARACTER VARYING(255),
     "ch4_emission_factor"       FLOAT,
     "ch4_emission_factor_units" CHARACTER VARYING(255),
     "n2o_emission_factor"       FLOAT,
     "n2o_emission_factor_units" CHARACTER VARYING(255)
  );
ALTER TABLE "automobile_type_fuel_years" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip
  def self.find_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
    if year > maximum(:year)
      where(:type_name => type_name, :fuel_family => fuel_family, :year => maximum(:year)).first
    else
      where(:type_name => type_name, :fuel_family => fuel_family, :year => [year, minimum(:year)].max).first
    end
  end
  
  # for calculating ch4 and n2o ef
  def type_fuel_year_controls
    AutomobileTypeFuelYearControl.find_all_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
  end
  
  
  warn_unless_size 124
end
