class Fuel < ActiveRecord::Base
  set_primary_key :name
  
  has_many :fuel_years, :foreign_key => 'fuel_name'
  
  data_miner do
    tap "Brighter Planet's fuels data", Earth.taps_server
  end
  
  def latest_year
    fuel_years.find_by_year(fuel_years.maximum('year'))
  end
  
  def energy_content
    if content = super
      content
    elsif fuel_years.present?
      latest_year.energy_content
    end
  end
  
  def energy_content_units
    if units = super
      units
    elsif fuel_years.present?
      latest_year.energy_content_units
    end
  end
  
  def carbon_content
    if content = super
      content
    elsif fuel_years.present?
      latest_year.carbon_content
    end
  end
  
  def carbon_content_units
    if units = super
      units
    elsif fuel_years.present?
      latest_year.carbon_content_units
    end
  end
  
  def oxidation_factor
    if oxidation_factor = super
      oxidation_factor
    elsif fuel_years.present?
      latest_year.oxidation_factor
    end
  end
  
  def biogenic_fraction
    if biogenic_fraction = super
      biogenic_fraction
    elsif fuel_years.present?
      latest_year.biogenic_fraction
    end
  end
  
  def co2_emission_factor
    if ef = super
      ef
    elsif fuel_years.present?
      latest_year.co2_emission_factor
    end
  end
  
  def co2_emission_factor_units
    if units = super
      units
    elsif fuel_years.present?
      latest_year.co2_emission_factor_units
    end
  end
  
  def co2_biogenic_emission_factor
    if ef = super
      ef
    elsif fuel_years.present?
      latest_year.co2_biogenic_emission_factor
    end
  end
  
  def co2_biogenic_emission_factor_units
    if units = super
      units
    elsif fuel_years.present?
      latest_year.co2_biogenic_emission_factor_units
    end
  end
end
