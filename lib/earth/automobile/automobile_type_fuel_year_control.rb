class AutomobileTypeFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :control, :class_name => 'AutomobileTypeFuelControl', :foreign_key => 'type_fuel_control_name'
  
  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :control_name
  col :type_fuel_control_name
  col :type_fuel_year_name
  col :total_travel_percent, :type => :float
end