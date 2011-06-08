class Carrier < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'carrier_name', :primary_key => 'name'
  
  # TODO calculate these
  falls_back_on :route_inefficiency_factor => 1.03,
                :transport_emission_factor => 0.0005266,
                :corporate_emission_factor => 0.221
  
  create_table do
    string 'name'
    float  'package_volume'
    float  'route_inefficiency_factor'
    float  'transport_emission_factor'
    string 'transport_emission_factor_units'
    float  'corporate_emission_factor'
    string 'corporate_emission_factor_units'
  end
end
