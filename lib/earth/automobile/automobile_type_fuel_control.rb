class AutomobileTypeFuelControl < ActiveRecord::Base
  set_primary_key :name
  create_table do
    string  'name'
    string  'type_name'
    string  'fuel_common_name'
    string  'control_name'
    float   'ch4_emission_factor'
    string  'ch4_emission_factor_units'
    float   'n2o_emission_factor'
    string  'n2o_emission_factor_units'
  end
end
