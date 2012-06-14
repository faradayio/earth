class AutomobileTypeFuel < ActiveRecord::Base
  self.primary_key = "name"
  
  # for calculating vehicles
  def latest_activity_year_type_fuel
    AutomobileActivityYearTypeFuel.latest.where(:type_name => type_name, :fuel_family => fuel_family).first
  end
  
  col :name
  col :type_name
  col :fuel_family
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :fuel_consumption, :type => :float
  col :fuel_consumption_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  col :vehicles, :type => :float
  
  warn_unless_size 4
end
