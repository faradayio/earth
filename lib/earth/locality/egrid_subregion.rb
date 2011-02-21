class EgridSubregion < ActiveRecord::Base
  set_primary_key :abbreviation
  
  has_many :zip_codes, :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  
  class << self
    def fallback_egrid_region
      EgridRegion.fallback
    end
  end
  
  falls_back_on :egrid_region => lambda { EgridSubregion.fallback_egrid_region },
                :electricity_co2_emission_factor => lambda { weighted_average(:electricity_co2_emission_factor, :weighted_by => :net_generation) },
                :electricity_co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :electricity_co2_biogenic_emission_factor => lambda { weighted_average(:electricity_co2_biogenic_emission_factor, :weighted_by => :net_generation) },
                :electricity_co2_biogenic_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :electricity_ch4_emission_factor => lambda { weighted_average(:electricity_ch4_emission_factor, :weighted_by => :net_generation) },
                :electricity_ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_n2o_emission_factor => lambda { weighted_average(:electricity_n2o_emission_factor, :weighted_by => :net_generation) },
                :electricity_n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :electricity_emission_factor => lambda { weighted_average(:electricity_emission_factor, :weighted_by => :net_generation) }, # DEPRECATED
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour' # DEPRECATED
  
  data_miner do
    tap "Brighter Planet's egrid subregion data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
