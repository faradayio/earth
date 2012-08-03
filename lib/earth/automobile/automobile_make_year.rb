require 'earth/model'

class AutomobileMakeYear < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE automobile_make_years
  (
     name                  CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     make_name             CHARACTER VARYING(255),
     year                  INTEGER,
     fuel_efficiency       FLOAT,
     fuel_efficiency_units CHARACTER VARYING(255),
     weighting             FLOAT                   /* for calculating AutomobileMake fuel efficiences */
  );

EOS

  self.primary_key = "name"
  
  warn_unless_size 1276
  warn_if_any_nulls
end
