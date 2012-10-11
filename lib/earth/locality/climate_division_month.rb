require 'earth/model'

require 'earth/locality/climate_division'

class ClimateDivisionMonth < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE climate_division_months
  (
     name                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     climate_division_name     CHARACTER VARYING(255),
     year                      INTEGER,
     month                     INTEGER,
     heating_degree_days       FLOAT,
     heating_degree_days_units CHARACTER VARYING(255),
     cooling_degree_days       FLOAT,
     cooling_degree_days_units CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :climate_division, :foreign_key => 'climate_division_name'
  
  warn_unless_size (344 * (((Date.today.year - 2011) * 12) + Date.today.prev_month.month))
  warn_if_any_nulls
end
