require 'earth/model'

class RailCompanyTraction < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE rail_company_tractions
  (
     name                        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     rail_company_name           CHARACTER VARYING(255),
     rail_traction_name          CHARACTER VARYING(255),
     electricity_intensity       FLOAT,
     electricity_intensity_units CHARACTER VARYING(255),
     diesel_intensity            FLOAT,
     diesel_intensity_units      CHARACTER VARYING(255),
     co2_emission_factor         FLOAT,
     co2_emission_factor_units   CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
end
