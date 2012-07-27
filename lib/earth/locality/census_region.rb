require 'earth/model'

class CensusRegion < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "census_regions"
  (
     "number" INTEGER NOT NULL,
     "name"   CHARACTER VARYING(255)
  );
ALTER TABLE "census_regions" ADD PRIMARY KEY ("number")
EOS

  self.primary_key = "number"
  
  has_many :census_divisions, :foreign_key => 'census_region_number'
  has_many :states, :through => :census_divisions
  # has_many :climate_divisions, :through => :census_divisions
  # has_many :zip_codes, :through => :census_divisions
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_region_number'
  

  warn_unless_size 4
end
