require 'earth/model'

require 'earth/automobile/automobile_activity_year_type_fuel'

class AutomobileActivityYearType < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_activity_year_types"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "activity_year"             INTEGER,
     "type_name"                 CHARACTER VARYING(255),
     "hfc_emissions"             FLOAT,
     "hfc_emissions_units"       CHARACTER VARYING(255),
     "hfc_emission_factor"       FLOAT,
     "hfc_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip
  def self.find_by_type_name_and_closest_year(type_name, year)
    candidates = where(:type_name => type_name)
    if year > (max_year = candidates.maximum(:activity_year))
      candidates.where(:activity_year => max_year).first
    else
      candidates.where(:activity_year => [year, candidates.minimum(:activity_year)].max).first
    end
  end
  
  # for calculating hfc ef
  def activity_year_type_fuels
    AutomobileActivityYearTypeFuel.where(:activity_year => activity_year, :type_name => type_name)
  end
  
  warn_unless_size 30
end
