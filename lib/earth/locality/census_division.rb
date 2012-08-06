require 'earth/model'
require 'falls_back_on'

require 'earth/locality/census_region'
require 'earth/locality/climate_division'
require 'earth/locality/state'
require 'earth/locality/zip_code'
require 'earth/residence/residential_energy_consumption_survey_response'

class CensusDivision < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "census_divisions"
  (
     "number"                                         INTEGER NOT NULL PRIMARY KEY,
     "name"                                           CHARACTER VARYING(255),
     "census_region_name"                             CHARACTER VARYING(255),
     "census_region_number"                           INTEGER,
     "meeting_building_natural_gas_intensity"         FLOAT,
     "meeting_building_natural_gas_intensity_units"   CHARACTER VARYING(255),
     "meeting_building_fuel_oil_intensity"            FLOAT,
     "meeting_building_fuel_oil_intensity_units"      CHARACTER VARYING(255),
     "meeting_building_electricity_intensity"         FLOAT,
     "meeting_building_electricity_intensity_units"   CHARACTER VARYING(255),
     "meeting_building_district_heat_intensity"       FLOAT,
     "meeting_building_district_heat_intensity_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "number"
  
  belongs_to :census_region, :foreign_key => 'census_region_number'
  has_many :states, :foreign_key => 'census_division_number'
  has_many :zip_codes, :through => :states
  has_many :climate_divisions, :through => :states
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_division_number'
  
  # https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFJ3U3VaSG1oQW1yclY3M3FsRzRDNFE&hl=en&output=html
  falls_back_on :name => 'fallback',
                :meeting_building_natural_gas_intensity => 0.0004353615 * 100.cubic_feet.to(:cubic_metres) / 1.square_feet.to(:square_metres),
                :meeting_building_fuel_oil_intensity => 0.0000925593.gallons.to(:litres) / 1.square_feet.to(:square_metres),
                :meeting_building_electricity_intensity => 0.0084323684 / 1.square_feet.to(:square_metres),
                :meeting_building_district_heat_intensity => 0.0004776370.kbtus.to(:megajoules) / 1.square_feet.to(:square_metres)
  
  warn_unless_size 9
end
