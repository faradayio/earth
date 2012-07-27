require 'earth/model'
require 'earth/locality'
require 'earth/industry/industry'

class MecsRatio < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "mecs_ratios"
  (
     "name"                                 CHARACTER VARYING(255) NOT NULL,
     "census_region_number"                 INTEGER,
     "naics_code"                           CHARACTER VARYING(255),
     "energy_per_dollar_of_shipments"       FLOAT,
     "energy_per_dollar_of_shipments_units" CHARACTER VARYING(255)
  );
ALTER TABLE "mecs_ratios" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  belongs_to :industry
  
  
  # Find the first record whose naics_code matches code and whose energy per dollar shipment is present.
  # If no record found chop off the last character of code and try again, and so on.
  def self.find_by_naics_code(code)
    candidate = find_by_naics_code_and_census_region_number(code, nil)
  end
  
  # Find the first record whose census_region_number matches number, whose naics_code matches code, and whose energy per dollar of shipments is present.
  # If none found and we know census region number, try looking nationwide
  # If none found and looking nationwide, chop off the last character of code and try again looking in census region
  # And so on
  def self.find_by_naics_code_and_census_region_number(code, number, original_number = number)
    if code.blank?
      record = nil
    else
      code = Industry.format_naics_code code
      candidate = where(:census_region_number => number, :naics_code => code).first
      
      if candidate.try(:energy_per_dollar_of_shipments).present?
        record = candidate
      elsif number.present?
        record = find_by_naics_code_and_census_region_number(code, nil, original_number)
      else
        record = find_by_naics_code_and_census_region_number(code[0..-2], original_number)
      end
    end
    record
  end
end
