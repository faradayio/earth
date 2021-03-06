require 'earth/model'

require 'earth/automobile/automobile_type_fuel_control'

class AutomobileTypeFuelYearControl < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE automobile_type_fuel_year_controls
  (
     name                   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     type_name              CHARACTER VARYING(255),
     fuel_family            CHARACTER VARYING(255),
     year                   INTEGER,
     control_name           CHARACTER VARYING(255),
     type_fuel_control_name CHARACTER VARYING(255),
     total_travel_percent   FLOAT
  );

EOS

  self.primary_key = "name"
  
  # Needs to be a belongs_to so that it gets imported with taps for AutomobileTypeFuelYear ch4 and n2o ef calculation
  belongs_to :type_fuel_control, :foreign_key => :type_fuel_control_name, :class_name => 'AutomobileTypeFuelControl'
  
  delegate :ch4_emission_factor, :ch4_emission_factor_units, :n2o_emission_factor, :n2o_emission_factor_units,
    :to => :type_fuel_control, :allow_nil => true
  
  # Used by AutomobileTypeFuelYear
  def self.find_all_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
    return if (candidates = where(:type_name => type_name, :fuel_family => fuel_family)).none?
    if year > (max_year = candidates.maximum(:year))
      candidates.where :year => max_year
    else
      candidates.where :year => [year, candidates.minimum(:year)].max
    end
  end
  
  warn_unless_size 142
end
