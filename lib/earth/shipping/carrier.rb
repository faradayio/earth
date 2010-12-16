class Carrier < ActiveRecord::Base
  set_primary_key :name
  
  has_many :carrier_modes, :foreign_key => 'carrier_name', :primary_key => 'name'
  
  # TODO calculate these
  falls_back_on :route_inefficiency_factor => 1.03,# Carrier.weighted_average(:route_inefficiency_factor, :weighted_by => :package_volume)
                :transport_emission_factor => 0.0005266,# Carrier.weighted_average(:transport_emission_factor, :weighted_by => :package_volume)
                :corporate_emission_factor => 0.221# Carrier.weighted_average(:corporate_emission_factor, :weighted_by => :package_volume)
  
  data_miner do
    tap "Brighter Planet's shipping company data", Earth.taps_server
  end
end
