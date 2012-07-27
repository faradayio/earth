require 'earth/model'

require 'earth/locality/egrid_subregion'

class ComputationCarrierRegion < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "computation_carrier_regions"
  (
     "name"                         CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "computation_carrier_name"     CHARACTER VARYING(255),
     "region"                       CHARACTER VARYING(255),
     "egrid_subregion_abbreviation" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :egrid_subregion, :foreign_key => 'egrid_subregion_abbreviation'


  warn_unless_size 4
end
