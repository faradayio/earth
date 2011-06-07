class AutomobileTypeFuelYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :year_controls, :class_name => 'AutomobileTypeFuelYearControl', :foreign_key => 'type_fuel_year_name'
  belongs_to :type_year, :class_name => 'AutomobileTypeYear', :foreign_key => 'type_year_name'
  
  create_table do
    string  'name'
    string  'type_name'
    string  'fuel_common_name'
    integer 'year'
    string  'type_year_name'
    float   'total_travel'
    string  'total_travel_units'
    float   'fuel_consumption'
    string  'fuel_consumption_units'
    float   'ch4_emission_factor'
    string  'ch4_emission_factor_units'
    float   'n2o_emission_factor'
    string  'n2o_emission_factor_units'
  end
end
