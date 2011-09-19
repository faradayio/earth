class AutomobileTypeYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :type_fuel_years, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_year_name'

  col :name
  col :type_name
  col :year, :type => :integer
  col :hfc_emissions, :type => :float
  col :hfc_emissions_units
  col :hfc_emission_factor, :type => :float
  col :hfc_emission_factor_units
end