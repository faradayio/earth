require 'earth/locality'
require 'earth/electricity/green_button_adoption'

class ElectricUtility < ActiveRecord::Base
  self.primary_key = "eia_id"
  
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  has_many :electric_markets
  has_many :zip_codes, :through => :electric_markets
  
  col :eia_id, :type => :integer
  col :name
  col :nickname
  col :state_postal_abbreviation
  col :nerc_region_abbreviation
  col :second_nerc_region_abbreviation

  def green_button_implementer?
    GreenButtonAdoption.implemented? name, nickname 
  end

  def green_button_committer?
    GreenButtonAdoption.committed? name, nickname
  end
end
