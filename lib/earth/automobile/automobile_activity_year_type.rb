class AutomobileActivityYearType < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip
  def self.find_by_type_name_and_closest_year(type_name, year)
    if year > maximum(:activity_year)
      where(:type_name => type_name, :activity_year => maximum(:activity_year)).first
    else
      where(:type_name => type_name, :activity_year => [year, minimum(:activity_year)].max).first
    end
  end
  
  # for calculating hfc ef
  def activity_year_type_fuels
    AutomobileActivityYearTypeFuel.where(:activity_year => activity_year, :type_name => type_name)
  end
  
  col :name
  col :activity_year, :type => :integer
  col :type_name
  col :hfc_emissions, :type => :float
  col :hfc_emissions_units
  col :hfc_emission_factor, :type => :float
  col :hfc_emission_factor_units
  
  warn_unless_size 30
end
