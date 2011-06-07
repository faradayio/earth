# DEPRECATED - use AutomobileTypeFuelYearAge
class AutomobileTypeFuelAge < ActiveRecord::Base
  set_primary_key :name
  
  create_table do
    string  'name'
    string  'type_name'
    string  'fuel_common_name'
    integer 'age'
    float   'age_percent'
    float   'total_travel_percent'
    float   'annual_distance'
    string  'annual_distance_units'
    integer 'vehicles'
  end
end
