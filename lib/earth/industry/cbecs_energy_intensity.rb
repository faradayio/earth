require 'earth/model'

class CbecsEnergyIntensity < ActiveRecord::Base
  FUELS = {
    :electricity => {
      :consumption => :billion_kilowatt_hours,
      :intensity => :kilowatt_hours_per_square_foot,
      :set => 10
    },
    :natural_gas => {
      :consumption => :billion_cubic_feet_of_natural_gas,
      :intensity => :cubic_feet_of_natural_gas_per_square_foot,
      :set => 11
    },
    :fuel_oil => {
      :consumption => :million_gallons_of_fuel_oil,
      :intensity => :gallons_of_fuel_oil_per_square_foot,
      :set => 12
    },
    :district_heat => {
      :consumption => :trillion_btu,
      :intensity => :trillion_btu_per_million_square_feet,
      :set => 13
    }
  }
  
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE cbecs_energy_intensities
  (
     name                           CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     principal_building_activity    CHARACTER VARYING(255),
     naics_code                     CHARACTER VARYING(255),
     census_region_number           INTEGER,
     census_division_number         INTEGER,
     electricity                    FLOAT,
     electricity_units              CHARACTER VARYING(255),
     electricity_floorspace         FLOAT,
     electricity_floorspace_units   CHARACTER VARYING(255),
     electricity_intensity          FLOAT,
     electricity_intensity_units    CHARACTER VARYING(255),
     natural_gas                    FLOAT,
     natural_gas_units              CHARACTER VARYING(255),
     natural_gas_floorspace         FLOAT,
     natural_gas_floorspace_units   CHARACTER VARYING(255),
     natural_gas_intensity          FLOAT,
     natural_gas_intensity_units    CHARACTER VARYING(255),
     fuel_oil                       FLOAT,
     fuel_oil_units                 CHARACTER VARYING(255),
     fuel_oil_floorspace            FLOAT,
     fuel_oil_floorspace_units      CHARACTER VARYING(255),
     fuel_oil_intensity             FLOAT,
     fuel_oil_intensity_units       CHARACTER VARYING(255),
     district_heat                  FLOAT,
     district_heat_units            CHARACTER VARYING(255),
     district_heat_floorspace       FLOAT,
     district_heat_floorspace_units CHARACTER VARYING(255),
     district_heat_intensity        FLOAT,
     district_heat_intensity_units  CHARACTER VARYING(255)
  );
CREATE INDEX index_cbecs_energy_intensities_on_naics_code ON cbecs_energy_intensities (naics_code);
CREATE INDEX index_cbecs_energy_intensities_on_census_region_number ON cbecs_energy_intensities (census_region_number);
CREATE INDEX index_cbecs_energy_intensities_on_census_division_number ON cbecs_energy_intensities (census_division_number)

EOS

  self.primary_key = "name"
  
  scope :divisional, where('census_region_number IS NOT NULL AND census_division_number IS NOT NULL')
  scope :regional, where('census_region_number IS NOT NULL AND census_division_number IS NULL')
  scope :national, where(:census_region_number => nil, :census_division_number => nil)

  # Find the first record whose naics_code matches code.
  # If no record found chop off the last character of code and try again, and so on.
  def self.find_by_naics_code(code)
    find_by_naics_code_and_census_field(code, :census_region_number, nil)
  end
  
  # Find the first record whose census_region_number matches number and whose naics_code matches code.
  # If no record found chop off the last character of code and try again, and so on.
  def self.find_by_naics_code_and_census_region_number(code, number)
    find_by_naics_code_and_census_field(code, :census_region_number, number)
  end
  
  # Find the first record whose census_division_number matches number and whose naics_code matches code.
  # If no record found chop off the last character of code and try again, and so on.
  def self.find_by_naics_code_and_census_division_number(code, number)
    find_by_naics_code_and_census_field(code, :census_division_number, number)
  end
  
  def self.find_by_naics_code_and_census_field(code, field, number)
    if code.blank?
      record = nil
    else
      record = where(field => number, :naics_code => code).first
      record ||= find_by_naics_code_and_census_field(code[0..-2], field, number)
    end
    record
  end
  
  def fuel_ratios
    energy = 0
    FUELS.keys.each { |fuel| energy += send(fuel).to_f }
    FUELS.keys.inject({}) do |ratios, fuel|
      ratios[fuel] = send(fuel).to_f / energy.to_f
      ratios
    end
  end
  
  warn_unless_size 182
end
