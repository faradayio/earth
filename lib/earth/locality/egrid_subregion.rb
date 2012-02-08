require 'earth/fuel'
class EgridSubregion < ActiveRecord::Base
  self.primary_key = :abbreviation
  
  has_many :zip_codes, :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  
  falls_back_on :name => 'fallback',
                :egrid_region => lambda { EgridRegion.fallback },
                :electricity_co2_emission_factor => lambda { weighted_average(:electricity_co2_emission_factor, :weighted_by => :net_generation) },
                :electricity_co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :electricity_co2_biogenic_emission_factor => lambda { weighted_average(:electricity_co2_biogenic_emission_factor, :weighted_by => :net_generation) },
                :electricity_co2_biogenic_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :electricity_ch4_emission_factor => lambda { weighted_average(:electricity_ch4_emission_factor, :weighted_by => :net_generation) },
                :electricity_ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_n2o_emission_factor => lambda { weighted_average(:electricity_n2o_emission_factor, :weighted_by => :net_generation) },
                :electricity_n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_emission_factor => lambda { weighted_average(:electricity_emission_factor, :weighted_by => :net_generation) },
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour'
  
  col :abbreviation
  col :name
  col :nerc_abbreviation
  col :egrid_region_name
  col :net_generation, :type => :float
  col :net_generation_units
  col :electricity_co2_emission_factor, :type => :float
  col :electricity_co2_emission_factor_units
  col :electricity_co2_biogenic_emission_factor, :type => :float
  col :electricity_co2_biogenic_emission_factor_units
  col :electricity_ch4_emission_factor, :type => :float
  col :electricity_ch4_emission_factor_units
  col :electricity_n2o_emission_factor, :type => :float
  col :electricity_n2o_emission_factor_units
  col :electricity_emission_factor, :type => :float
  col :electricity_emission_factor_units
end
