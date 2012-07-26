class ClimateDivision < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "climate_divisions"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL,
     "heating_degree_days"       FLOAT,
     "heating_degree_days_units" CHARACTER VARYING(255),
     "cooling_degree_days"       FLOAT,
     "cooling_degree_days_units" CHARACTER VARYING(255),
     "state_postal_abbreviation" CHARACTER VARYING(255)
  );
ALTER TABLE "climate_divisions" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750
  

  warn_unless_size 359
end
