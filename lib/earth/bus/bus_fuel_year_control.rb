class BusFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel_control, :class_name => 'BusFuelControl', :foreign_key => 'bus_fuel_control_name'

  create_table do
    string  'name'
    string  'bus_fuel_name'
    integer 'year'
    string  'control'
    string  'bus_fuel_control_name'
    float   'total_travel_percent'
  end
end
