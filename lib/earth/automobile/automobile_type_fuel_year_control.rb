class AutomobileTypeFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :control, :class_name => 'AutomobileTypeFuelControl', :foreign_key => 'type_fuel_control_name'
  
  force_schema do
    string  'name'
    string  'type_name'
    string  'fuel_common_name'
    integer 'year'
    string  'control_name'
    string  'type_fuel_control_name'
    string  'type_fuel_year_name'
    float   'total_travel_percent'
  end
end
