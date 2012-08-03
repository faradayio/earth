require 'earth/model'

class DietClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "diet_classes"
  (
     "name"                     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "intensity"                FLOAT,
     "intensity_units"          CHARACTER VARYING(255),
     "red_meat_share"           FLOAT,
     "poultry_share"            FLOAT,
     "fish_share"               FLOAT,
     "eggs_share"               FLOAT,
     "nuts_share"               FLOAT,
     "dairy_share"              FLOAT,
     "cereals_and_grains_share" FLOAT,
     "fruit_share"              FLOAT,
     "vegetables_share"         FLOAT,
     "oils_and_sugars_share"    FLOAT
  );
EOS

  self.primary_key = "name"
  
  class << self
    def fallback
      find_by_name 'standard'
    end
  end
  
  warn_unless_size 3
end
