require 'earth/model'

require 'earth/electricity/electric_market'
require 'earth/electricity/green_button_adoption'
require 'earth/locality/state'
require 'earth/locality/zip_code'

class ElectricUtility < ActiveRecord::Base
  data_miner do
    process "Data mine GreenButtonAdoption because it's like a belongs_to association" do
      GreenButtonAdoption.run_data_miner!
    end
  end
  
  extend Earth::Model
  
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "electric_utilities"
  (
     "eia_id"                          INTEGER NOT NULL PRIMARY KEY,
     "name"                            CHARACTER VARYING(255),
     "nickname"                        CHARACTER VARYING(255),
     "state_postal_abbreviation"       CHARACTER VARYING(255),
     "nerc_region_abbreviation"        CHARACTER VARYING(255),
     "second_nerc_region_abbreviation" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "eia_id"
  
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  has_many :electric_markets, :foreign_key => :electric_utility_eia_id
  has_many :zip_codes, :through => :electric_markets
  
  def green_button_implementer?
    GreenButtonAdoption.implemented? name, nickname
  end
  
  def green_button_committer?
    GreenButtonAdoption.committed? name, nickname
  end
  
  warn_unless_size 3265
end
