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
    def fallback_latest_type_fuel_year_ages
      AutomobileTypeFuelYearAge.where(:year => AutomobileTypeFuelYearAge.maximum('year'))
    end
    
    def fallback_annual_distance
      fallback_latest_type_fuel_year_ages.weighted_average(:annual_distance, :weighted_by => :vehicles)
    end
    
    def fallback_annual_distance_units
      fallback_latest_type_fuel_year_ages.first.annual_distance_units
    end
    
    def fallback_blend_portion
      latest_year = AutomobileTypeFuelYear.maximum('year')
      gas_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'gasoline').sum('fuel_consumption')
      diesel_use = AutomobileTypeFuelYear.where(:year => latest_year, :fuel_common_name => 'diesel').sum('fuel_consumption')
      diesel_use / (gas_use + diesel_use)
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

  force_schema do
    string 'name'
    string 'code'
    string 'base_fuel_name'
    string 'blend_fuel_name'
    float  'blend_portion' # the portion of the blend that is the blend fuel
    string 'distance_key' # used to look up annual distance from AutomobileTypeFuelYear
    string 'ef_key' # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
    float  'annual_distance'
    string 'annual_distance_units'
    float  'co2_emission_factor'
    string 'co2_emission_factor_units'
    float  'co2_biogenic_emission_factor'
    string 'co2_biogenic_emission_factor_units'
    float  'ch4_emission_factor'
    string 'ch4_emission_factor_units'
    float  'n2o_emission_factor'
    string 'n2o_emission_factor_units'
    float  'hfc_emission_factor'
    string 'hfc_emission_factor_units'
    float  'emission_factor' # DEPRECATED but motorcycle needs this
    string 'emission_factor_units' # DEPRECATED but motorcycle needs this
  end

  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
