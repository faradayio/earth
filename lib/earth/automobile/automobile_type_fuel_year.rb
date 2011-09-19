class AutomobileTypeFuelYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :year_controls, :class_name => 'AutomobileTypeFuelYearControl', :foreign_key => 'type_fuel_year_name'
  belongs_to :type_year, :class_name => 'AutomobileTypeYear', :foreign_key => 'type_year_name'
  
  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :type_year_name
  col :total_travel, :type => :float
  col :total_travel_units
  col :fuel_consumption, :type => :float
  col :fuel_consumption_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end