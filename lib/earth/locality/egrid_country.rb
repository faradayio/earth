require 'earth/model'

class EgridCountry < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE egrid_countries
  (
     name                       CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     generation                 FLOAT,
     generation_units           CHARACTER VARYING(255),
     foreign_interchange        FLOAT,
     foreign_interchange_units  CHARACTER VARYING(255),
     domestic_interchange       FLOAT,
     domestic_interchange_units CHARACTER VARYING(255),
     consumption                FLOAT,
     consumption_units          CHARACTER VARYING(255),
     loss_factor                FLOAT
  );

EOS

  self.primary_key = "name"
  
  class << self
    def us
      find_by_name 'U.S.'
    end
  end
  
  
  warn_unless_size 1
  warn_if_any_nulls
end
