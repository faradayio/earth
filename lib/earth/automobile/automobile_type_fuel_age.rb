# DEPRECATED - use AutomobileTypeFuelYearAge
class AutomobileTypeFuelAge < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :type_name
  col :fuel_common_name
  col :age, :type => :integer
  col :age_percent, :type => :float
  col :total_travel_percent, :type => :float
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :vehicles, :type => :integer
end