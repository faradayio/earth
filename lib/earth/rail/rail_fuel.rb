class RailFuel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  
  [:density, :density_units, :co2_emission_factor, :co2_emission_factor_units, :co2_biogenic_emission_factor, :co2_biogenic_emission_factor_units].each do |method|
    define_method method do
      fuel.send(method)
    end
  end
  
  col :name
  col :fuel_name
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
end