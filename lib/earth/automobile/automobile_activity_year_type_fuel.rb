require 'earth/model'

class AutomobileActivityYearTypeFuel < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE automobile_activity_year_type_fuels
  (
     name                   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     activity_year          INTEGER,
     type_name              CHARACTER VARYING(255),
     fuel_family            CHARACTER VARYING(255),
     distance               FLOAT,
     distance_units         CHARACTER VARYING(255),
     fuel_consumption       FLOAT,
     fuel_consumption_units CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  # Used by AutomobileFuel to get records from latest activity year
  def self.latest
    where(:activity_year => maximum(:activity_year))
  end
  
  
  warn_unless_size 120
end
