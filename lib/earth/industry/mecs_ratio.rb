require 'earth/locality'
require 'earth/industry/industry'

class MecsRatio < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :industry
  
  col :name
  col :census_region_number, :type => :integer
  col :naics_code
  col :energy_per_dollar_of_shipments, :type => :float
  col :energy_per_dollar_of_shipments_units
  
  # Find the first MecsRatio whose census_region matches census_region and whose naics_code starts with code.
  # If none found, chop off the last character of code and try again, continuing until code is blank.
  def self.find_by_naics_code_and_census_region(code, census_region)
    if code.blank?
      record = nil
    else
      code = Industry.format_naics_code code
      record = where('census_region = ? AND naics_code LIKE ?', census_region, "#{code}%").first
      record ||= find_by_naics_code_and_census_region(code[0..-2], census_region)
    end
    record
  end
end
