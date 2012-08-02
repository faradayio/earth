require 'falls_back_on'

require 'earth/model'

class AutomobileSizeClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_size_classes"
  (
     "name"                                            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "type_name"                                       CHARACTER VARYING(255),
     "fuel_efficiency_city"                            FLOAT,
     "fuel_efficiency_city_units"                      CHARACTER VARYING(255),
     "fuel_efficiency_highway"                         FLOAT,
     "fuel_efficiency_highway_units"                   CHARACTER VARYING(255),
     "hybrid_fuel_efficiency_city_multiplier"          FLOAT,
     "hybrid_fuel_efficiency_highway_multiplier"       FLOAT,
     "conventional_fuel_efficiency_city_multiplier"    FLOAT,
     "conventional_fuel_efficiency_highway_multiplier" FLOAT
  );
EOS

  self.primary_key = "name"
  
  # FIXME TODO clean up size class in MakeModelYearVariant, derive size class for MakeModelYear, and calculate this from MakeModelYear
  falls_back_on :hybrid_fuel_efficiency_city_multiplier => 1.651, # https://brighterplanet.sifterapp.com/issue/667
                :hybrid_fuel_efficiency_highway_multiplier => 1.213,
                :conventional_fuel_efficiency_city_multiplier => 0.987,
                :conventional_fuel_efficiency_highway_multiplier => 0.996
  
  warn_unless_size 15
  warn_if_nulls_except(
    :hybrid_fuel_efficiency_city_multiplier,
    :hybrid_fuel_efficiency_highway_multiplier,
    :conventional_fuel_efficiency_city_multiplier,
    :conventional_fuel_efficiency_highway_multiplier
  )
end
