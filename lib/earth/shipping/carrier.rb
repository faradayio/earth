class Carrier < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'carrier_name', :primary_key => 'name'
  
  # TODO calculate these
  falls_back_on :route_inefficiency_factor => 1.03,
                :transport_emission_factor => 0.0005266,
                :corporate_emission_factor => 0.221
  
  col :name
  col :package_volume, :type => :float
  col :route_inefficiency_factor, :type => :float
  col :transport_emission_factor, :type => :float
  col :transport_emission_factor_units
  col :corporate_emission_factor, :type => :float
  col :corporate_emission_factor_units
end