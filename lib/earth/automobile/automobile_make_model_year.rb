class AutomobileMakeModelYear < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_make_model_years"
  (
     "name"                              CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "make_name"                         CHARACTER VARYING(255),
     "model_name"                        CHARACTER VARYING(255),
     "year"                              INTEGER,
     "hybridity"                         BOOLEAN,
     "fuel_code"                         CHARACTER VARYING(255),
     "fuel_efficiency_city"              FLOAT,
     "fuel_efficiency_city_units"        CHARACTER VARYING(255),
     "fuel_efficiency_highway"           FLOAT,
     "fuel_efficiency_highway_units"     CHARACTER VARYING(255),
     "alt_fuel_code"                     CHARACTER VARYING(255),
     "alt_fuel_efficiency_city"          FLOAT,
     "alt_fuel_efficiency_city_units"    CHARACTER VARYING(255),
     "alt_fuel_efficiency_highway"       FLOAT,
     "alt_fuel_efficiency_highway_units" CHARACTER VARYING(255),
     "type_name"                         CHARACTER VARYING(255), /* whether the vehicle is a passenger car or light-duty truck */
     "weighting"                         FLOAT                   /* for calculating AutomobileMakeModel fuel efficiencies */
  );
EOS

  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip to look up auto fuel and alt auto fuel
  belongs_to :automobile_fuel,     :foreign_key => 'fuel_code',     :primary_key => 'code'
  belongs_to :alt_automobile_fuel, :foreign_key => 'alt_fuel_code', :primary_key => 'code', :class_name => 'AutomobileFuel'
  
  warn_unless_size 10997
  warn_if_nulls_except :alt_fuel_code
  warn_if_nulls /alt_fuel_efficiency/, :conditions => 'alt_fuel_code IS NOT NULL'
end
