class AutomobileTypeFuelYearControl < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_type_fuel_year_controls"
  (
     "name"                   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "type_name"              CHARACTER VARYING(255),
     "fuel_family"            CHARACTER VARYING(255),
     "year"                   INTEGER,
     "control_name"           CHARACTER VARYING(255),
     "type_fuel_control_name" CHARACTER VARYING(255),
     "total_travel_percent"   FLOAT
  );
EOS

  self.primary_key = "name"
  
  # Needs to be a belongs_to so that it gets imported with taps for AutomobileTypeFuelYear ch4 and n2o ef calculation
  belongs_to :type_fuel_control, :foreign_key => :type_fuel_control_name, :class_name => 'AutomobileTypeFuelControl'
  
  # Used by AutomobileTypeFuelYear
  def self.find_all_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
    if year > maximum(:year)
      where(:type_name => type_name, :fuel_family => fuel_family, :year => maximum(:year))
    else
      where(:type_name => type_name, :fuel_family => fuel_family, :year => [year, minimum(:year)].max)
    end
  end
  
  %w{ ch4_emission_factor n2o_emission_factor }.each do |method|
    define_method method do
      type_fuel_control.send(method)
    end
    
    units_method = method + '_units'
    define_method units_method do
      type_fuel_control.send(units_method)
    end
  end
  
  
  warn_unless_size 142
end
