class State < ActiveRecord::Base
  self.primary_key = "postal_abbreviation"
  
  has_many :zip_codes,         :foreign_key => 'state_postal_abbreviation'
  has_many :climate_divisions, :foreign_key => 'state_postal_abbreviation'
  belongs_to :census_division, :foreign_key => 'census_division_number'
  has_one :census_region, :through => :census_division
  has_one :electricity_mix, :foreign_key => 'state_postal_abbreviation'
  belongs_to :petroleum_administration_for_defense_district, :foreign_key => 'petroleum_administration_for_defense_district_code'
  
  data_miner do
    process "Ensure Country and ElectricityMix are imported because they're like belongs_to associations" do
      Country.run_data_miner!
      ElectricityMix.run_data_miner!
    end
  end
  
  def country
    Country.united_states
  end
  
  col :postal_abbreviation
  col :fips_code, :type => :integer
  col :name
  col :census_division_number, :type => :integer
  col :petroleum_administration_for_defense_district_code
  col :population, :type => :integer
  col :electricity_emission_factor, :type => :float
  col :electricity_emission_factor_units
  col :electricity_loss_factor, :type => :float
  
  warn_if_nulls_except(
    :census_division_number,
    :petroleum_administration_for_defense_district_code
  )
  
  warn_unless_size 51
end
