class FuelCountry < ActiveRecord::Base
  set_primary_key :name
  
  has_many :fuel_country_years, :foreign_key => 'fuel_country_name'
  
  data_miner do
    tap "Brighter Planet's country-specific fuel data", Earth.taps_server
  end
  
  def latest_country_year
    fuel_country_years.find_by_year(fuel_country_years.maximum('year'))
  end
  
  def co2_emission_factor
    if ef = super
      ef
    elsif fuel_country_years.present?
      latest_country_year.co2_emission_factor
    end
  end
  
  def co2_emission_factor_units
    if units = super
      units
    elsif fuel_country_years.present?
      latest_country_year.co2_emission_factor_units
    end
  end
  
  def co2_biogenic_emission_factor
    if ef = super
      ef
    elsif fuel_country_years.present?
      latest_country_year.co2_biogenic_emission_factor
    end
  end
  
  def co2_biogenic_emission_factor_units
    if units = super
      units
    elsif fuel_country_years.present?
      latest_country_year.co2_biogenic_emission_factor_units
    end
  end
end
