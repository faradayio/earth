require 'earth/automobile/automobile_type_fuel_year_age'
require 'earth/automobile/automobile_type_fuel_year'
require 'earth/automobile/automobile_type_year'
require 'earth/fuel/greenhouse_gas'

class AutomobileFuel < ActiveRecord::Base
  set_primary_key :name
  
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
    
    def fallback_annual_distance
      (AutomobileFuel.find_by_code("R").annual_distance * (1 - AutomobileFuel.fallback_blend_portion)) +
      (AutomobileFuel.find_by_code("D").annual_distance * AutomobileFuel.fallback_blend_portion)
    end
    
    def fallback_annual_distance_units
      AutomobileFuel.find_by_code("R").annual_distance_units
    end
    
    def fallback_co2_emission_factor
      (Fuel.find_by_name("Motor Gasoline").co2_emission_factor * (1 - AutomobileFuel.fallback_blend_portion)) +
      (Fuel.find_by_name("Distillate Fuel Oil No. 2").co2_emission_factor * AutomobileFuel.fallback_blend_portion)
    end
    
    def fallback_co2_emission_factor_units
      Fuel.find_by_name("Motor Gasoline").co2_emission_factor_units
    end
    
    def fallback_co2_biogenic_emission_factor
      (Fuel.find_by_name("Motor Gasoline").co2_biogenic_emission_factor * (1 - AutomobileFuel.fallback_blend_portion)) +
      (Fuel.find_by_name("Distillate Fuel Oil No. 2").co2_biogenic_emission_factor * AutomobileFuel.fallback_blend_portion)
    end
    
    def fallback_co2_biogenic_emission_factor_units
      Fuel.find_by_name("Motor Gasoline").co2_biogenic_emission_factor_units
    end
    
    def fallback_latest_type_fuel_years
      AutomobileTypeFuelYear.where(:year => AutomobileTypeFuelYear.maximum('year'))
    end
    
    def fallback_ch4_emission_factor
      fallback_latest_type_fuel_years.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:ch4].global_warming_potential
    end
    
    def fallback_ch4_emission_factor_units
      prefix = fallback_latest_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[0]
      suffix = fallback_latest_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[1]
      prefix + "_co2e_per_" + suffix
    end
    
    def fallback_n2o_emission_factor
      fallback_latest_type_fuel_years.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:n2o].global_warming_potential
    end
    
    def fallback_n2o_emission_factor_units
      prefix = fallback_latest_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[0]
      suffix = fallback_latest_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[1]
      prefix + "_co2e_per_" + suffix
    end
    
    def fallback_hfc_emission_factor
      fallback_latest_type_fuel_years.map do |tfy|
        tfy.total_travel * tfy.type_year.hfc_emission_factor
      end.sum / fallback_latest_type_fuel_years.sum('total_travel')
    end
    
    def fallback_hfc_emission_factor_units
      fallback_latest_type_fuel_years.first.type_year.hfc_emission_factor_units
    end
  end
  
  falls_back_on :name => 'fallback',
                :annual_distance => lambda { AutomobileFuel.fallback_annual_distance },
                :annual_distance_units => lambda { AutomobileFuel.fallback_annual_distance_units },
                :co2_emission_factor => lambda { AutomobileFuel.fallback_co2_emission_factor },
                :co2_emission_factor_units => lambda { AutomobileFuel.fallback_co2_emission_factor_units },
                :co2_biogenic_emission_factor => lambda { AutomobileFuel.fallback_co2_biogenic_emission_factor },
                :co2_biogenic_emission_factor_units => lambda { AutomobileFuel.fallback_co2_biogenic_emission_factor_units },
                :ch4_emission_factor => lambda { AutomobileFuel.fallback_ch4_emission_factor },
                :ch4_emission_factor_units => lambda { AutomobileFuel.fallback_ch4_emission_factor_units },
                :n2o_emission_factor => lambda { AutomobileFuel.fallback_n2o_emission_factor },
                :n2o_emission_factor_units => lambda { AutomobileFuel.fallback_n2o_emission_factor_units },
                :hfc_emission_factor => lambda { AutomobileFuel.fallback_hfc_emission_factor },
                :hfc_emission_factor_units => lambda { AutomobileFuel.fallback_hfc_emission_factor_units }
  
  data_miner do
    tap "Brighter Planet's sanitized automobile fuel data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
