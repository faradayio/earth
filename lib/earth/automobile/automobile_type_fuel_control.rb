class AutomobileTypeFuelControl < ActiveRecord::Base
  self.primary_key = "name"

  col :name
  col :type_name
  col :fuel_family
  col :control_name
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  
  warn_unless_size 20
end
