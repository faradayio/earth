require 'earth/fuel'
class CensusDivision < ActiveRecord::Base
  self.primary_key = "number"
  
  belongs_to :census_region, :foreign_key => 'census_region_number'
  has_many :states, :foreign_key => 'census_division_number'
  has_many :zip_codes, :through => :states
  has_many :climate_divisions, :through => :states
  has_many :residential_energy_consumption_survey_responses, :foreign_key => 'census_division_number'
  
  # https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFJ3U3VaSG1oQW1yclY3M3FsRzRDNFE&hl=en&output=html
  falls_back_on :meeting_building_natural_gas_intensity => 0.0004353615 * 100.cubic_feet.to.cubic_metres.to_f / 1.square_feet.to.square_metres.to_f,
                :meeting_building_fuel_oil_intensity => 0.0000925593.gallons.to.litres.to_f / 1.square_feet.to.square_metres.to_f,
                :meeting_building_electricity_intensity => 0.0084323684 / 1.square_foot.to.square_metres.to_f,
                :meeting_building_district_heat_intensity => 0.0004776370.kbtus.to.megajoules.to_f / 1.square_foot.to.square_metres.to_f
  
  col :number, :type => :integer
  col :name
  col :census_region_name
  col :census_region_number, :type => :integer
  col :meeting_building_natural_gas_intensity, :type => :float
  col :meeting_building_natural_gas_intensity_units
  col :meeting_building_fuel_oil_intensity, :type => :float
  col :meeting_building_fuel_oil_intensity_units
  col :meeting_building_electricity_intensity, :type => :float
  col :meeting_building_electricity_intensity_units
  col :meeting_building_district_heat_intensity, :type => :float
  col :meeting_building_district_heat_intensity_units
end
