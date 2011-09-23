class EgridSubregion < ActiveRecord::Base
  set_primary_key :abbreviation
  
  has_many :zip_codes, :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :egrid_region, :foreign_key => 'egrid_region_name'
  
  class << self
    def fallback_egrid_region
      EgridRegion.fallback
    end
  end
  
  falls_back_on :name => 'fallback',
                :egrid_region => lambda { EgridSubregion.fallback_egrid_region },
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
  
  # FIXME TODO verify egrid_region_name is found in EgridRegions
  # %w{ egrid_region_name }.each do |attribute|
  #   verify "#{attribute.humanize} should never be missing" do
  #     EgridSubregion.all.each do |subregion|
  #       unless subregion.send("#{attribute}").present?
  #         raise "Missing #{attribute.humanize.downcase} for EgridSubregion #{subregion.name}"
  #       end
  #     end
  #   end
  # end
  # 
  # ["net_generation",
  #  "electricity_co2_emission_factor",
  #  "electricity_ch4_emission_factor",
  #  "electricity_n2o_emission_factor",
  #  "electricity_emission_factor" ].each do |attribute|
  #   verify "#{attribute.humanize} should be > 0" do
  #     EgridSubregion.all.each do |subregion|
  #       value = subregion.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute.humanize.downcase} for EgridSubregion #{subregion.name}: #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Electricity co2 biogenic emission factor should be 0" do
  #   EgridSubregion.all.each do |subregion|
  #     value = subregion.electricity_co2_biogenic_emission_factor
  #     unless value == 0
  #       raise "Invalid electricity co2 biogenic emission factor for EgridSubregion #{subregion.name}: #{value} (should be 0)"
  #     end
  #   end
  # end
  # 
  # [["net_generation_units","megawatt_hours"],
  #  ["electricity_co2_emission_factor_units","kilograms_per_kilowatt_hour"],
  #  ["electricity_co2_biogenic_emission_factor_units","kilograms_per_kilowatt_hour"],
  #  ["electricity_ch4_emission_factor_units","kilograms_co2e_per_kilowatt_hour"],
  #  ["electricity_n2o_emission_factor_units","kilograms_co2e_per_kilowatt_hour"],
  #  ["electricity_emission_factor_units","kilograms_co2e_per_kilowatt_hour"]].each do |pair|
  #   attribute = pair[0]
  #   proper_units = pair[1]
  #   verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
  #     EgridSubregion.all.each do |subregion|
  #       units = subregion.send(:"#{attribute}")
  #       unless units == proper_units
  #         raise "Invalid #{attribute.humanize.downcase} for EgridSubregion #{subregion.name}: #{units} (should be #{proper_units})"
  #       end
  #     end
  #   end
  # end
  
  # FIXME TODO verify fallbacks
end
