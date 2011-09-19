class BusFuel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  has_many :fuel_year_controls, :class_name => 'BusFuelYearControl', :foreign_key => 'bus_fuel_name'
    
  def latest_fuel_year_controls
    fuel_year_controls.where(:year => fuel_year_controls.maximum('year'))
  end
  
  col :name
  col :fuel_name
  col :energy_content, :type => :float
  col :energy_content_units
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end