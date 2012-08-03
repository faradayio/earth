require 'earth/model'

require 'earth/bus/bus_fuel_control'

class BusFuelYearControl < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "bus_fuel_year_controls"
  (
     "name"                  CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "bus_fuel_name"         CHARACTER VARYING(255),
     "year"                  INTEGER,
     "control"               CHARACTER VARYING(255),
     "bus_fuel_control_name" CHARACTER VARYING(255),
     "total_travel_percent"  FLOAT
  );
EOS

  self.primary_key = "name"
  
  belongs_to :fuel_control, :class_name => 'BusFuelControl', :foreign_key => 'bus_fuel_control_name'

  warn_unless_size 67
end
