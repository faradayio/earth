require 'falls_back_on'

require 'earth/model'

require 'earth/electricity/electricity_mix'
require 'earth/locality/egrid_region'

class EgridSubregion < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "egrid_subregions"
  (
     "abbreviation"                       CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "name"                               CHARACTER VARYING(255),
     "nerc_abbreviation"                  CHARACTER VARYING(255),
     "egrid_region_name"                  CHARACTER VARYING(255),
     "net_generation"                     FLOAT,
     "net_generation_units"               CHARACTER VARYING(255),
     "co2_emission_factor"                FLOAT,
     "co2_emission_factor_units"          CHARACTER VARYING(255),
     "co2_biogenic_emission_factor"       FLOAT,
     "co2_biogenic_emission_factor_units" CHARACTER VARYING(255),
     "ch4_emission_factor"                FLOAT,
     "ch4_emission_factor_units"          CHARACTER VARYING(255),
     "n2o_emission_factor"                FLOAT,
     "n2o_emission_factor_units"          CHARACTER VARYING(255),
     "electricity_emission_factor"        FLOAT,
     "electricity_emission_factor_units"  CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "abbreviation"
  
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  has_one :electricity_mix, :foreign_key => 'egrid_subregion_abbreviation'
  
  falls_back_on :name => 'fallback',
                :egrid_region => lambda { EgridRegion.fallback },
                :co2_emission_factor => lambda { weighted_average(:co2_emission_factor, :weighted_by => :net_generation) },
                :co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :co2_biogenic_emission_factor => lambda { weighted_average(:co2_biogenic_emission_factor, :weighted_by => :net_generation) },
                :co2_biogenic_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :ch4_emission_factor => lambda { weighted_average(:ch4_emission_factor, :weighted_by => :net_generation) },
                :ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :n2o_emission_factor => lambda { weighted_average(:n2o_emission_factor, :weighted_by => :net_generation) },
                :n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_emission_factor => lambda { weighted_average(:electricity_emission_factor, :weighted_by => :net_generation) },
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour'
  
  
  warn_unless_size 26
  warn_if_any_nulls
end
