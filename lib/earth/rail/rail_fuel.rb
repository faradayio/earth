require 'earth/fuel'
class RailFuel < ActiveRecord::Base
  self.primary_key = "name"
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  
  delegate :density, :density_units, :co2_emission_factor, :co2_emission_factor_units, :co2_biogenic_emission_factor, :co2_biogenic_emission_factor_units, :to => :fuel, :allow_nil => true
  
  col :name
  col :fuel_name
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end
