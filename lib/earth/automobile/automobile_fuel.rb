require 'earth/automobile/automobile_type_fuel_year_age'
require 'earth/automobile/automobile_type_fuel_year'
require 'earth/automobile/automobile_type_year'
require 'earth/fuel/greenhouse_gas'

class AutomobileFuel < ActiveRecord::Base
  set_primary_key :code
  
  scope :ordered, :order => 'name'
  
  has_many :type_fuel_year_ages, :class_name => 'AutomobileTypeFuelYearAge', :foreign_key => 'fuel_common_name', :primary_key => 'distance_key'
  has_many :type_fuel_years,     :class_name => 'AutomobileTypeFuelYear',    :foreign_key => 'fuel_common_name', :primary_key => 'ef_key'
  belongs_to :base_fuel,         :class_name => 'Fuel',                      :foreign_key => 'base_fuel_name'
  belongs_to :blend_fuel,        :class_name => 'Fuel',                      :foreign_key => 'blend_fuel_name'
  
  class << self
    def fallback_blend_portion
      latest_year = AutomobileTypeFuelYear.maximum('year')
      gas_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'gasoline').sum('fuel_consumption')
      diesel_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'diesel').sum('fuel_consumption')
      diesel_use / (gas_use + diesel_use)
    end
  end
  
  falls_back_on :name => 'fallback',
                :base_fuel_name => 'Motor Gasoline',
                :blend_fuel_name => 'Distillate Fuel Oil No. 2',
                :blend_portion => lambda { AutomobileFuel.fallback_blend_portion },
                :distance_key => 'fallback',
                :ef_key => 'fallback'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile fuel type data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  # FIXME TODO should I run data miner on has_many associations?
  # AutomobileTypeFuelYearAge
  # => AutomobileTypeFuelYearControl
  # => AutomobileTypeFuelControl
  # AutomobileTypeYear
  
  # FIXME TODO should I run data miner on other classes we need?
  # Fuel
  # => FuelYear
  # GreenhouseGas
  
  def annual_distance # returns km
    scope = type_fuel_year_ages.any? ? type_fuel_year_ages : AutomobileTypeFuelYearAge
    scope.where(:year => scope.maximum('year')).weighted_average(:annual_distance, :weighted_by => :vehicles)
  end
  
  def co2_emission_factor # returns kg co2 / litre
    if blend_fuel.present?
      (base_fuel.co2_emission_factor * (1 - blend_portion)) + (blend_fuel.co2_emission_factor * blend_portion)
    else
      base_fuel.co2_emission_factor
    end
  end
  
  def co2_biogenic_emission_factor # returns kg co2 / litre
    if blend_fuel.present?
      (base_fuel.co2_biogenic_emission_factor * (1 - blend_portion)) + (blend_fuel.co2_biogenic_emission_factor * blend_portion)
    else
      base_fuel.co2_biogenic_emission_factor
    end
  end
  
  def latest_type_fuel_years
    scope = type_fuel_years.any? ? type_fuel_years : AutomobileTypeFuelYear
    scope.where(:year => scope.maximum('year'))
  end
  
  def ch4_emission_factor # returns kg co2e / litre
    latest_type_fuel_years.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:ch4].global_warming_potential
  end
  
  def n2o_emission_factor # returns kg co2e / litre
    latest_type_fuel_years.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:n2o].global_warming_potential
  end
  
  def hfc_emission_factor # returns kg co2e / litre (hfc emission factor is already in co2e)
    latest_type_fuel_years.map do |type_fuel_year|
      type_fuel_year.total_travel * type_fuel_year.type_year.hfc_emission_factor
    end.sum / latest_type_fuel_years.sum('total_travel')
  end
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
