require 'earth/model'

class ClimateDivision < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "climate_divisions"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "heating_degree_days"       FLOAT,
     "heating_degree_days_units" CHARACTER VARYING(255),
     "cooling_degree_days"       FLOAT,
     "cooling_degree_days_units" CHARACTER VARYING(255),
     "state_postal_abbreviation" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750
  

  warn_unless_size 359
end
