class AutomobileTypeFuelYearAge < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :type_fuel_year, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_fuel_year_name'

  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :age, :type => :integer
  col :type_fuel_year_name
  col :total_travel_percent, :type => :float
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :vehicles, :type => :integer
end