class FuelYear < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :fuel_name
  col :year, :type => :integer
  col :energy_content, :type => :float
  col :energy_content_units
  col :carbon_content, :type => :float
  col :carbon_content_units
  col :oxidation_factor, :type => :float
  col :biogenic_fraction, :type => :float
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
end