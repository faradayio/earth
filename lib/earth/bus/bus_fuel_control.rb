require 'earth/fuel'
class BusFuelControl < ActiveRecord::Base
  set_primary_key :name
  col :name
  col :bus_fuel_name
  col :control
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end