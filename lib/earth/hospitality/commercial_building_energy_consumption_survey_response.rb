require 'earth/locality'
class CommercialBuildingEnergyConsumptionSurveyResponse < ActiveRecord::Base
  set_primary_key :id
  set_table_name :cbecs_responses
  
  extend CohortScope
  self.minimum_cohort_size = 8 # CBECS doesn't report averages based on fewer than 20 samples
  
  col :id,                     :type => :integer
  col :census_region_number,   :type => :integer
  col :census_division_number, :type => :integer
  col :heating_degree_days,    :type => :integer
  col :cooling_degree_days,    :type => :integer
  col :construction_year,      :type => :integer
  col :area,                   :type => :float
  col :area_units
  col :floors,                 :type => :integer
  col :lodging_rooms,          :type => :integer
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
  col :natural_gas_use,        :type => :float
  col :natural_gas_use_units
  col :fuel_oil_use,           :type => :float
  col :fuel_oil_use_units
  col :district_heat_use,      :type => :float
  col :district_heat_use_units
  col :stratum,                :type => :integer
  col :pair,                   :type => :integer
  col :weighting,              :type => :float
end
