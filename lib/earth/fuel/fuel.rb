class Fuel < ActiveRecord::Base
  self.primary_key = :name
  
  has_many :fuel_years, :foreign_key => 'fuel_name'
  
  col :name
  col :density, :type => :float
  col :density_units
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
