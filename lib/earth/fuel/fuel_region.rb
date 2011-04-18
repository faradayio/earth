class FuelRegion < ActiveRecord::Base
  set_primary_key :name
  
  has_many :fuel_region_years, :foreign_key => 'fuel_region_name'
  
  data_miner do
    tap "Brighter Planet's region-specific fuel data", Earth.taps_server
  end
  
  def latest_region_year
    fuel_region_years.find_by_year(fuel_region_years.maximum('year'))
  end
  
  def co2_emission_factor
    if ef = super
      ef
    elsif fuel_region_years.present?
      latest_region_year.co2_emission_factor
    end
  end
  
  def co2_emission_factor_units
    if units = super
      units
    elsif fuel_region_years.present?
      latest_region_year.co2_emission_factor_units
    end
  end
  
  def co2_biogenic_emission_factor
    if ef = super
      ef
    elsif fuel_region_years.present?
      latest_region_year.co2_biogenic_emission_factor
    end
  end
  
  def co2_biogenic_emission_factor_units
    if units = super
      units
    elsif fuel_region_years.present?
      latest_region_year.co2_biogenic_emission_factor_units
    end
  end
end
