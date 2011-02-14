class Fuel < ActiveRecord::Base
  set_primary_key :name
  
  has_many :fuel_years, :foreign_key => 'fuel_name'
  
  data_miner do
    tap "Brighter Planet's fuels data", Earth.taps_server
  end
  
  def energy_content
    if non_variable_energy_content = super
      non_variable_energy_content
    elsif fuel_years.present?
      latest_year = fuel_years.maximum('year')
      fuel_years.find_by_year(latest_year).energy_content
    end
  end
  
  def carbon_content
    if non_variable_carbon_content = super
      non_variable_carbon_content
    elsif fuel_years.present?
      latest_year = fuel_years.maximum('year')
      fuel_years.find_by_year(latest_year).carbon_content
    end
  end
end
