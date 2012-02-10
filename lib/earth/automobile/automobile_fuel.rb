require 'earth/fuel'

class AutomobileFuel < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :type_fuel_year_ages, :class_name => 'AutomobileTypeFuelYearAge', :foreign_key => 'fuel_common_name', :primary_key => 'distance_key'
  has_many :type_fuel_years,     :class_name => 'AutomobileTypeFuelYear',    :foreign_key => 'fuel_common_name', :primary_key => 'ef_key'
  belongs_to :base_fuel,         :class_name => 'Fuel',                      :foreign_key => 'base_fuel_name'
  belongs_to :blend_fuel,        :class_name => 'Fuel',                      :foreign_key => 'blend_fuel_name'
    
  warn_if_blanks_in :distance_key
  warn_if_blanks_in :ef_key
  warn do
    catch :culprit do
      find_each do |record|
        throw :culprit, %{Records exist without base_fuel (possibly invalid key "#{record.base_fuel_name}")} unless record.base_fuel
      end
      false
    end
  end
  warn do
    if exists?(['blend_portion IS NOT NULL AND (blend_portion < ? OR blend_portion > ?)', 0, 1])
      "Blend portions less than 0 or greater than 1"
    end
  end
  warn do
    %w{co2_emission_factor co2_biogenic_emission_factor}.map do |col|
      if exists?(["#{col} IS NULL OR #{col} < ?", 0])
        "Records non-positive #{col}"
      end
    end
  end
  
  class << self
    def fallback_type_fuel_year_ages
      AutomobileTypeFuelYearAge.where(:year => AutomobileTypeFuelYearAge.maximum('year'))
    end
    
    def fallback_type_fuel_years
      AutomobileTypeFuelYear.where(:year => AutomobileTypeFuelYear.maximum('year'))
    end
    
    def fallback_type_years
      AutomobileTypeYear.where(:year => AutomobileTypeYear.maximum('year'))
    end
    
    # FIXME TODO for some reason this causes the fallbacks calculation to hang (infinite loop?) if it's defined as a fallback
    def fallback_blend_portion
      gas_use = fallback_type_fuel_years.where(:fuel_common_name => 'gasoline').sum('fuel_consumption').to_f
      diesel_use = fallback_type_fuel_years.where(:fuel_common_name => 'diesel').sum('fuel_consumption').to_f
      diesel_use / (gas_use + diesel_use)
    end
  end
  
  falls_back_on :name => 'fallback',
                :annual_distance => lambda { fallback_type_fuel_year_ages.weighted_average(:annual_distance, :weighted_by => :vehicles) },
                :annual_distance_units => lambda { fallback_type_fuel_year_ages.first.annual_distance_units },
                :energy_content => lambda {
                  (Fuel.find_by_name('Motor Gasoline').energy_content * (1 - fallback_blend_portion)) +
                  (Fuel.find_by_name('Distillate Fuel Oil No. 2').energy_content * fallback_blend_portion)
                },
                :co2_emission_factor => lambda {
                  (Fuel.find_by_name("Motor Gasoline").co2_emission_factor * (1 - fallback_blend_portion)) +
                  (Fuel.find_by_name("Distillate Fuel Oil No. 2").co2_emission_factor * fallback_blend_portion)
                },
                :co2_emission_factor_units => lambda { Fuel.find_by_name("Motor Gasoline").co2_emission_factor_units },
                :co2_biogenic_emission_factor => lambda {
                  (Fuel.find_by_name("Motor Gasoline").co2_biogenic_emission_factor * (1 - AutomobileFuel.fallback_blend_portion)) +
                  (Fuel.find_by_name("Distillate Fuel Oil No. 2").co2_biogenic_emission_factor * AutomobileFuel.fallback_blend_portion)
                },
                :co2_biogenic_emission_factor_units => lambda { Fuel.find_by_name("Motor Gasoline").co2_biogenic_emission_factor_units },
                :ch4_emission_factor => lambda { fallback_type_fuel_years.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:ch4].global_warming_potential },
                :ch4_emission_factor_units => lambda {
                  prefix = fallback_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[0]
                  suffix = fallback_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[1]
                  prefix + "_co2e_per_" + suffix
                },
                :n2o_emission_factor => lambda {
                  fallback_type_fuel_years.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:n2o].global_warming_potential
                },
                :n2o_emission_factor_units => lambda {
                  prefix = fallback_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[0]
                  suffix = fallback_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[1]
                  prefix + "_co2e_per_" + suffix
                },
                :hfc_emission_factor => lambda { fallback_type_years.weighted_average(:hfc_emission_factor, :weighted_by => [:type_fuel_years, :total_travel]) },
                :hfc_emission_factor_units => lambda { fallback_type_years.first.hfc_emission_factor_units }
  
  col :name
  col :code
  col :base_fuel_name
  col :blend_fuel_name
  col :blend_portion,                :type => :float # the portion of the blend that is the blend fuel
  col :distance_key                                  # used to look up annual distance from AutomobileTypeFuelYear
  col :ef_key                                        # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
  col :annual_distance,              :type => :float
  col :annual_distance_units
  col :energy_content,               :type => :float
  col :energy_content_units
  col :co2_emission_factor,          :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
  col :ch4_emission_factor,          :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor,          :type => :float
  col :n2o_emission_factor_units
  col :hfc_emission_factor,          :type => :float
  col :hfc_emission_factor_units
  col :emission_factor,              :type => :float # DEPRECATED but motorcycle needs this
  col :emission_factor_units # FIXME TODO DEPRECATED but motorcycle needs this
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
