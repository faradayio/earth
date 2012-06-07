require 'earth/fuel'
class BusFuelYearControl < ActiveRecord::Base
  self.primary_key = "name"
  
  belongs_to :fuel_control, :class_name => 'BusFuelControl', :foreign_key => 'bus_fuel_control_name'

  col :name
  col :bus_fuel_name
  col :year, :type => :integer
  col :control
  col :bus_fuel_control_name
  col :total_travel_percent, :type => :float

  warn_unless_size 67
end
