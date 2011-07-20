class BusFuelControl < ActiveRecord::Base
  set_primary_key :name
  force_schema do
    string 'name'
    string 'bus_fuel_name'
    string 'control'
    float  'ch4_emission_factor'
    string 'ch4_emission_factor_units'
    float  'n2o_emission_factor'
    string 'n2o_emission_factor_units'
  end
end
