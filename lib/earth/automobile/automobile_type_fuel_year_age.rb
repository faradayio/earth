class AutomobileTypeFuelYearAge < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :type_fuel_year, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_fuel_year_name'

  force_schema do
    string  'name'
    string  'type_name'
    string  'fuel_common_name'
    integer 'year'
    integer 'age'
    string  'type_fuel_year_name'
    float   'total_travel_percent'
    float   'annual_distance'
    string  'annual_distance_units'
    integer 'vehicles'
  end
end
