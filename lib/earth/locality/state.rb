class State < ActiveRecord::Base
  set_primary_key :postal_abbreviation
  
  has_many :climate_divisions, :foreign_key => 'state_postal_abbreviation'
  has_many :zip_codes, :foreign_key => 'state_postal_abbreviation'
  belongs_to :census_division, :foreign_key => 'census_division_number'
  belongs_to :petroleum_administration_for_defense_district, :foreign_key => 'petroleum_administration_for_defense_district_code'
  has_one :census_region, :through => :census_division
  
  def country
    Country.united_states
  end

  col :postal_abbreviation
  col :fips_code, :type => :integer
  col :name
  col :census_division_number
  col :petroleum_administration_for_defense_district_code
end