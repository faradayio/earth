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

  data_miner do
    tap "Brighter Planet's sanitized states", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end

end
