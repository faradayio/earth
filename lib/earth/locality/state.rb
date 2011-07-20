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

  force_schema do
    string   'postal_abbreviation'
    integer  'fips_code'
    string   'name'
    string   'census_division_number'
    string   'petroleum_administration_for_defense_district_code'
  end
end
