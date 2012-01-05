require 'earth/locality'
require 'earth/industry/industry'

class MecsRatio < ActiveRecord::Base
  set_primary_key :name

  col :name
  col :census_region
  col :naics_code
  col :consumption_per_dollar_of_shipments, :type => :float
  
  belongs_to :industry

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
