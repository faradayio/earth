class Fuel < ActiveRecord::Base
  set_primary_key :name
  
  has_many :fuel_years, :foreign_key => 'fuel_name'
  
  data_miner do
    tap "Brighter Planet's fuels data", Earth.taps_server
  end
  
  def energy_content
    if non_variable_energy_content = super
      non_variable_energy_content
    elsif latest_fuel_year = fuel_years.last
      latest_fuel_year.energy_content
    end
  end
  
  def carbon_content
    if non_variable_carbon_content = super
      non_variable_carbon_content
    elsif latest_fuel_year = fuel_years.last
      latest_fuel_year.carbon_content
    end
  end
end
