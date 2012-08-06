require 'earth/model'

require 'earth/locality/census_division'
require 'earth/locality/census_region'
require 'earth/locality/climate_division'
require 'earth/locality/country'
require 'earth/locality/electricity_mix'
require 'earth/locality/petroleum_administration_for_defense_district'
require 'earth/locality/zip_code'

class State < ActiveRecord::Base
  data_miner do
    process "Ensure Country and ElectricityMix are imported because they're like belongs_to associations" do
      Country.run_data_miner!
      ElectricityMix.run_data_miner!
    end
  end

  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "states"
  (
     "postal_abbreviation"                                CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "fips_code"                                          INTEGER,
     "name"                                               CHARACTER VARYING(255),
     "census_division_number"                             INTEGER,
     "petroleum_administration_for_defense_district_code" CHARACTER VARYING(255),
     "population"                                         INTEGER,
     "electricity_emission_factor"                        FLOAT,
     "electricity_emission_factor_units"                  CHARACTER VARYING(255),
     "electricity_loss_factor"                            FLOAT
  );
EOS

  self.primary_key = "postal_abbreviation"
  
  has_many :zip_codes,         :foreign_key => 'state_postal_abbreviation'
  has_many :climate_divisions, :foreign_key => 'state_postal_abbreviation'
  belongs_to :census_division, :foreign_key => 'census_division_number'
  has_one :census_region, :through => :census_division
  has_one :electricity_mix, :foreign_key => 'state_postal_abbreviation'
  belongs_to :petroleum_administration_for_defense_district, :foreign_key => 'petroleum_administration_for_defense_district_code'
  
  def country
    Country.united_states
  end
  
  warn_if_nulls_except(
    :census_division_number,
    :petroleum_administration_for_defense_district_code
  )
  
  warn_unless_size 51
end
