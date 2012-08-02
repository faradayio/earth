require 'earth/model'

class GreenhouseGas < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "greenhouse_gases"
  (
     "name"                     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "abbreviation"             CHARACTER VARYING(255),
     "ipcc_report"              CHARACTER VARYING(255),
     "time_horizon"             INTEGER,
     "time_horizon_units"       CHARACTER VARYING(255),
     "global_warming_potential" INTEGER
  );
EOS

  self.primary_key = "name"
    
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
  
  warn_unless_size 4
end
