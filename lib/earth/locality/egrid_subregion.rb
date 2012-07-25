require 'earth/locality/egrid_region'

class EgridSubregion < ActiveRecord::Base
  self.primary_key = "abbreviation"
  
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  has_one :electricity_mix, :foreign_key => 'egrid_subregion_abbreviation'
  
  falls_back_on :name => 'fallback',
                :egrid_region => lambda { EgridRegion.fallback },
                :co2_emission_factor => lambda { weighted_average(:co2_emission_factor, :weighted_by => :net_generation) },
                :co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :co2_biogenic_emission_factor => lambda { weighted_average(:co2_biogenic_emission_factor, :weighted_by => :net_generation) },
                :co2_biogenic_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :ch4_emission_factor => lambda { weighted_average(:ch4_emission_factor, :weighted_by => :net_generation) },
                :ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :n2o_emission_factor => lambda { weighted_average(:n2o_emission_factor, :weighted_by => :net_generation) },
                :n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_emission_factor => lambda { weighted_average(:electricity_emission_factor, :weighted_by => :net_generation) },
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour'
  
  col :abbreviation
  col :name
  col :nerc_abbreviation
  col :egrid_region_name
  col :net_generation, :type => :float
  col :net_generation_units
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  col :electricity_emission_factor, :type => :float
  col :electricity_emission_factor_units
  
  warn_unless_size 26
  warn_if_any_nulls
end
