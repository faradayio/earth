require 'earth/locality'
require 'earth/industry/industry'

class MecsRatio < ActiveRecord::Base
  self.primary_key = :name
  
  belongs_to :industry
  
  col :name
  col :census_region_number, :type => :integer
  col :naics_code
  col :energy_per_dollar_of_shipments, :type => :float
  col :energy_per_dollar_of_shipments_units
  
  # Find the first MecsRatio whose census_region_number matches number and whose naics_code matches code.
  # If none found, chop off the last character of code and try again, and so on.
  def self.find_by_naics_code_and_census_region_number(code, number)
    if code.blank?
      record = nil
    else
      code = Industry.format_naics_code code
      record = where('census_region_number = ? AND naics_code = ?', number, code).first
      record ||= find_by_naics_code_and_census_region_number(code[0..-2], number)
    end
    record
  end
end
