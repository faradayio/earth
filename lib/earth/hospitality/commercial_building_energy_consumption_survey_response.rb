require 'earth/locality'
class CommercialBuildingEnergyConsumptionSurveyResponse < ActiveRecord::Base
  self.primary_key = :id
  self.table_name = :cbecs_responses
  
  extend CohortScope
  self.minimum_cohort_size = 8 # CBECS doesn't report averages based on fewer than 20 samples
  
  def self.lodging_records
    where :detailed_activity => ['Hotel', 'Motel or inn']
  end
  
  col :id,                     :type => :integer
  col :census_region_number,   :type => :integer
  col :census_division_number, :type => :integer
  col :climate_zone_number,    :type => :integer
  col :heating_degree_days,    :type => :float
  col :heating_degree_days_units
  col :cooling_degree_days,    :type => :float
  col :cooling_degree_days_units
  col :construction_year,      :type => :integer
  col :area,                   :type => :float
  col :area_units
  col :floors,                 :type => :integer
  col :lodging_rooms,          :type => :integer
  col :percent_cooled,         :type => :float
  col :principal_activity
  col :detailed_activity
  col :first_activity
  col :second_activity
  col :third_activity
  col :first_activity_share,   :type => :float
  col :second_activity_share,  :type => :float
  col :third_activity_share,   :type => :float
  col :months_used,            :type => :integer
  col :weekly_hours,           :type => :integer
  col :electricity_use,        :type => :float
  col :electricity_use_units
  col :electricity_energy,     :type => :float
  col :electricity_energy_units
  col :natural_gas_use,        :type => :float
  col :natural_gas_use_units
  col :natural_gas_energy,     :type => :float
  col :natural_gas_energy_units
  col :fuel_oil_use,           :type => :float
  col :fuel_oil_use_units
  col :fuel_oil_energy,        :type => :float
  col :fuel_oil_energy_units
  col :steam_use,              :type => :float
  col :steam_use_units
  col :stratum,                :type => :integer
  col :pair,                   :type => :integer
  col :weighting,              :type => :float
end
