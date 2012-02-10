require 'earth/locality'

class CbecsEnergyIntensity < ActiveRecord::Base
  self.primary_key = :name
  
  col :name, :index => true
  col :principal_building_activity
  col :naics_code, :index => true
  col :census_region_number, :type => :integer, :index => true
  col :census_division_number, :type => :integer, :index => true

  col :electricity, :type => :float
  col :electricity_units
  col :electricity_floorspace, :type => :float
  col :electricity_floorspace_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units

  col :natural_gas, :type => :float
  col :natural_gas_units
  col :natural_gas_floorspace, :type => :float
  col :natural_gas_floorspace_units
  col :natural_gas_intensity, :type => :float
  col :natural_gas_intensity_units

  col :fuel_oil, :type => :float
  col :fuel_oil_units
  col :fuel_oil_floorspace, :type => :float
  col :fuel_oil_floorspace_units
  col :fuel_oil_intensity, :type => :float
  col :fuel_oil_intensity_units

  col :district_heat, :type => :float
  col :district_heat_units
  col :district_heat_floorspace, :type => :float
  col :district_heat_floorspace_units
  col :district_heat_intensity, :type => :float
  col :district_heat_intensity_units

  scope :divisional, where('census_region_number IS NOT NULL AND census_division_number IS NOT NULL')
  scope :regional, where('census_region_number IS NOT NULL AND census_division_number IS NULL')
  scope :national, where(:census_region_number => nil, :census_division_number => nil)
  
  # Find the first record whose census_division_number matches number and whose naics_code matches code.
  # If no record found chop off the last character of code and try again, and so on.
  def self.find_by_naics_code_and_census_division_number(code, number)
    if code.blank?
      record = nil
    else
      record = where('census_division_number = ? AND naics_code = ?', number, code).first
      record ||= find_by_naics_code_and_census_division_number(code[0..-2], number)
    end
    record
  end
end
