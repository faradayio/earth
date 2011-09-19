class AutomobileTypeFuelControl < ActiveRecord::Base
  set_primary_key :name
  col :name
  col :type_name
  col :fuel_common_name
  col :control_name
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end