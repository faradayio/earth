class AutomobileTypeYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :type_fuel_years, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_year_name'

  force_schema do
    string  'name'
    string  'type_name'
    integer 'year'
    float   'hfc_emissions'
    string  'hfc_emissions_units'
    float   'hfc_emission_factor'
    string  'hfc_emission_factor_units'
  end
end
