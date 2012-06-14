class AutomobileTypeFuelYear < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip
  def self.find_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
    if year > maximum(:year)
      where(:type_name => type_name, :fuel_family => fuel_family, :year => maximum(:year)).first
    else
      where(:type_name => type_name, :fuel_family => fuel_family, :year => [year, minimum(:year)].max).first
    end
  end
  
  # for calculating ch4 and n2o ef
  def type_fuel_year_controls
    AutomobileTypeFuelYearControl.find_all_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
  end
  
  col :name
  col :type_name
  col :fuel_family
  col :year, :type => :integer
  col :share_of_type, :type => :float
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  
  warn_unless_size 124
end
