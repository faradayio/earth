require 'earth/automobile/automobile_type_fuel_year_age'
require 'earth/automobile/automobile_type_fuel_year'
require 'earth/automobile/automobile_type_year'

class AutomobileFuel < ActiveRecord::Base
  set_primary_key :name
  
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
  
  # FIXME TODO verify that base_fuel_name and blend_fuel_name are found in Fuel if present
  # FIXME TODO verify that distance_key is found in AutomobileTypeFuelYearAge
  # FIXME TODO verify that ef_key is found in AutomobileTypeFuelYear
  
  # TODO convert these to warn blocks  
  # ["ch4_emission_factor", "n2o_emission_factor", "hfc_emission_factor"].each do |attribute|
  #   verify "#{attribute.humanize} should be > 0" do
  #     find_each do |fuel|
  #       value = fuel.send(attribute)
  #       unless value > 0
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # [["co2_emission_factor_units", "kilograms_per_litre"],
  #  ["co2_biogenic_emission_factor_units", "kilograms_per_litre"],
  #  ["ch4_emission_factor_units", "kilograms_co2e_per_litre"],
  #  ["n2o_emission_factor_units", "kilograms_co2e_per_litre"],
  #  ["hfc_emission_factor_units", "kilograms_co2e_per_litre"]].each do |pair|
  #   attribute = pair[0]
  #   proper_units = pair[1]
  #   verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
  #     find_each do |fuel|
  #       units = fuel.send(attribute)
  #       unless units == proper_units
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{units} (should be #{proper_units})"
  #       end
  #     end
  #   end
  # end
  
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
      diesel_use.to_f / (gas_use + diesel_use)
    end
    
    def fallback_co2_emission_factor
      (Fuel.find_by_name("Motor Gasoline").co2_emission_factor.to_f * (1 - AutomobileFuel.fallback_blend_portion)) +
      (Fuel.find_by_name("Distillate Fuel Oil No. 2").co2_emission_factor.to_f * AutomobileFuel.fallback_blend_portion)
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
      fallback_latest_type_fuel_years.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel).to_f * GreenhouseGas[:ch4].global_warming_potential
    end
    
    def fallback_ch4_emission_factor_units
      prefix = fallback_latest_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[0]
      suffix = fallback_latest_type_fuel_years.first.ch4_emission_factor_units.split("_per_")[1]
      prefix + "_co2e_per_" + suffix
    end
    
    def fallback_n2o_emission_factor
      fallback_latest_type_fuel_years.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel).to_f * GreenhouseGas[:n2o].global_warming_potential
    end
    
    def fallback_n2o_emission_factor_units
      prefix = fallback_latest_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[0]
      suffix = fallback_latest_type_fuel_years.first.n2o_emission_factor_units.split("_per_")[1]
      prefix + "_co2e_per_" + suffix
    end
    
    def fallback_hfc_emission_factor
      fallback_latest_type_fuel_years.map do |tfy|
        tfy.total_travel.to_f * tfy.type_year.hfc_emission_factor
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

  col :name
  col :code
  col :base_fuel_name
  col :blend_fuel_name
  col :blend_portion, :type => :float # the portion of the blend that is the blend fuel
  col :distance_key # used to look up annual distance from AutomobileTypeFuelYear
  col :ef_key # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  col :hfc_emission_factor, :type => :float
  col :hfc_emission_factor_units
  col :emission_factor, :type => :float # DEPRECATED but motorcycle needs this
  col :emission_factor_units # DEPRECATED but motorcycle needs this

  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end