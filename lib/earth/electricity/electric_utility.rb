require 'earth/locality'

class ElectricUtility < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "electric_utilities"
  (
     "eia_id"                          INTEGER NOT NULL,
     "name"                            CHARACTER VARYING(255),
     "nickname"                        CHARACTER VARYING(255),
     "state_postal_abbreviation"       CHARACTER VARYING(255),
     "nerc_region_abbreviation"        CHARACTER VARYING(255),
     "second_nerc_region_abbreviation" CHARACTER VARYING(255)
  );
ALTER TABLE "electric_utilities" ADD PRIMARY KEY ("eia_id")
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
end
