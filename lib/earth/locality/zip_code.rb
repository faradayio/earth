require 'earth/model'
require 'earth/loader'

require 'earth/locality/climate_division'
require 'earth/locality/country'
require 'earth/locality/egrid_subregion'
require 'earth/locality/state'
require 'earth/electricity/electric_market'
require 'earth/electricity/electric_utility'

require 'geocoder'

class ZipCode < ActiveRecord::Base
  data_miner do
    process "Ensure Country is imported because it's like a belongs_to association" do
      Country.run_data_miner!
    end
  end

  extend Earth::Model
  # extend Geocoder::Model::ActiveRecord
  # Geocoder::Configuration.units = :km

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE zip_codes
  (
     name                         CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     state_postal_abbreviation    CHARACTER VARYING(255),
     description                  CHARACTER VARYING(255),
     latitude                     FLOAT,
     longitude                    FLOAT,
     egrid_subregion_abbreviation CHARACTER VARYING(255),
     climate_division_name        CHARACTER VARYING(255),
     population                   INTEGER
  );

EOS

  self.primary_key = "name"
  
  belongs_to :climate_division, :foreign_key => 'climate_division_name'
  belongs_to :state,            :foreign_key => 'state_postal_abbreviation'
  belongs_to :egrid_subregion,  :foreign_key => 'egrid_subregion_abbreviation'
  has_many :electric_markets,   :foreign_key => 'zip_code_name'
  has_many :electric_utilities, :through => :electric_markets
  
  scope :known_subregion, where('egrid_subregion_abbreviation IS NOT NULL')

  # reverse_geocoded_by :latitude, :longitude

  def country
    Country.united_states
  end

  warn_unless_size 43770
  warn_if_nonexistent_owner_except :egrid_subregion
end
