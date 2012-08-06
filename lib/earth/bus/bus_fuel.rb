require 'earth/model'

require 'earth/bus/bus_fuel_year_control'
require 'earth/fuel/fuel'

class BusFuel < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE bus_fuels
  (
     name                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     fuel_name                          CHARACTER VARYING(255),
     energy_content                     FLOAT,
     energy_content_units               CHARACTER VARYING(255),
     co2_emission_factor                FLOAT,
     co2_emission_factor_units          CHARACTER VARYING(255),
     co2_biogenic_emission_factor       FLOAT,
     co2_biogenic_emission_factor_units CHARACTER VARYING(255),
     ch4_emission_factor                FLOAT,
     ch4_emission_factor_units          CHARACTER VARYING(255),
     n2o_emission_factor                FLOAT,
     n2o_emission_factor_units          CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  has_many :fuel_year_controls, :class_name => 'BusFuelYearControl', :foreign_key => 'bus_fuel_name'
    
  def latest_fuel_year_controls
    fuel_year_controls.where :year => fuel_year_controls.maximum(:year)
  end
  
  warn_unless_size 7
end
