require 'earth/locality'

class CbecsEnergyIntensity < ActiveRecord::Base
  self.primary_key = :name
  
  col :name
  col :naics_code
  col :census_division_number, :type => :integer
  col :electricity, :type => :float
  col :electricity_units
  col :floorspace, :type => :float
  col :floorspace_units
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  
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
