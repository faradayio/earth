require 'earth/model'
require 'falls_back_on'

class ElectricityMix < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE electricity_mixes
  (
     name                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     egrid_subregion_abbreviation       CHARACTER VARYING(255),
     state_postal_abbreviation          CHARACTER VARYING(255),
     country_iso_3166_code              CHARACTER VARYING(255),
     co2_emission_factor                FLOAT,
     co2_emission_factor_units          CHARACTER VARYING(255),
     co2_biogenic_emission_factor       FLOAT,
     co2_biogenic_emission_factor_units CHARACTER VARYING(255),
     ch4_emission_factor                FLOAT,
     ch4_emission_factor_units          CHARACTER VARYING(255),
     n2o_emission_factor                FLOAT,
     n2o_emission_factor_units          CHARACTER VARYING(255),
     loss_factor                        FLOAT
  );

EOS

  self.primary_key = :name
  
  def energy_content
    1.kilowatt_hours.to(:megajoules)
  end
  
  def energy_content_units
    'megajoules_per_kilowatt_hour'
  end
  
  falls_back_on :name => 'fallback',
                :co2_emission_factor => 0.623537, # from ecometrica paper FIXME TODO calculate this
                :co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :ch4_emission_factor => 0.000208, # from ecometrica paper FIXME TODO calculate this
                :ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :n2o_emission_factor => 0.002344, # from ecometrica paper FIXME TODO calculate this
                :n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :loss_factor => 0.096 # from ecometrica paper FIXME TODO calculate this
  
  warn_unless_size 213
  warn_if_any_nulls
end
