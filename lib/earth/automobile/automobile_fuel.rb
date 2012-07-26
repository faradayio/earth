require 'earth/fuel'

class AutomobileFuel < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_fuels"
  (
     "name"                               CHARACTER VARYING(255) NOT NULL,
     "code"                               CHARACTER VARYING(255),
     "family"                             CHARACTER VARYING(255),
     "distance_key"                       CHARACTER VARYING(255),
     "base_fuel_name"                     CHARACTER VARYING(255),
     "blend_fuel_name"                    CHARACTER VARYING(255),
     "blend_portion"                      FLOAT,                  /* the portion of the blend that is the blend fuel */
     "annual_distance"                    FLOAT,
     "annual_distance_units"              CHARACTER VARYING(255),
     "energy_content"                     FLOAT,
     "energy_content_units"               CHARACTER VARYING(255),
     "co2_emission_factor"                FLOAT,
     "co2_emission_factor_units"          CHARACTER VARYING(255),
     "co2_biogenic_emission_factor"       FLOAT,
     "co2_biogenic_emission_factor_units" CHARACTER VARYING(255),
     "ch4_emission_factor"                FLOAT,
     "ch4_emission_factor_units"          CHARACTER VARYING(255),
     "n2o_emission_factor"                FLOAT,
     "n2o_emission_factor_units"          CHARACTER VARYING(255),
     "total_consumption"                  FLOAT,                  /* for calculating fallback blend_portion */
     "total_consumption_units"            CHARACTER VARYING(255)
  );
ALTER TABLE "automobile_fuels" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  # for calculating energy content and co2 efs
  belongs_to :base_fuel,  :class_name => 'Fuel', :foreign_key => 'base_fuel_name'
  belongs_to :blend_fuel, :class_name => 'Fuel', :foreign_key => 'blend_fuel_name'
  
  # for calculating gas and diesel annual distance and ch4 + n2o efs
  has_many :type_fuels, :foreign_key => :fuel_family, :primary_key => :family, :class_name => 'AutomobileTypeFuel'
  
  # for fallback
  class << self
    def diesel
      find 'diesel'
    end
    
    def gasoline
      find 'gasoline'
    end
    
    def fallback_blend_portion
      diesel.total_consumption / (diesel.total_consumption + gasoline.total_consumption)
    end
    
    def determine_fallback(method)
      if method =~ /units/
        gasoline.send(method)
      else
        (fallback_blend_portion * diesel.send(method)) + ((1 - fallback_blend_portion) * gasoline.send(method))
      end
    end
  end
  
  # Used by Automobile and AutomobileTrip to determine whether need to convert fuel efficiency units
  def non_liquid?
    energy_content_units != 'megajoules_per_litre'
  end
  
  # Used by Automobile and AutomobileTrip to check whether user-input fuel matches one of the vehicle's fuels
  def same_as?(other_auto_fuel)
    unless other_auto_fuel.nil?
      if ['G', 'R', 'P'].include? self.code
        ['G', 'R', 'P'].include? other_auto_fuel.code
      else
        self == other_auto_fuel
      end
    end
  end
  
  # for AutomobileMakeModel.custom_find
  def suffix
    case code
    when 'D', 'BP-B5', 'BP-B20', 'BP-B100'
      'DIESEL'
    when 'E'
      'FFV'
    when 'C'
      'CNG'
    end
  end
  
  falls_back_on :name => 'fallback',
                :base_fuel_name => 'Motor Gasoline',
                :blend_fuel_name => 'Distillate Fuel Oil No. 2',
                :blend_portion                      => proc { AutomobileFuel.fallback_blend_portion },
                :annual_distance                    => proc { AutomobileFuel.determine_fallback 'annual_distance' },
                :annual_distance_units              => proc { AutomobileFuel.determine_fallback 'annual_distance_units' },
                :energy_content                     => proc { AutomobileFuel.determine_fallback 'energy_content' },
                :energy_content_units               => proc { AutomobileFuel.determine_fallback 'energy_content_units' },
                :co2_emission_factor                => proc { AutomobileFuel.determine_fallback 'co2_emission_factor' },
                :co2_emission_factor_units          => proc { AutomobileFuel.determine_fallback 'co2_emission_factor_units' },
                :co2_biogenic_emission_factor       => proc { AutomobileFuel.determine_fallback 'co2_biogenic_emission_factor' },
                :co2_biogenic_emission_factor_units => proc { AutomobileFuel.determine_fallback 'co2_biogenic_emission_factor_units' },
                :ch4_emission_factor                => proc { AutomobileFuel.determine_fallback 'ch4_emission_factor' },
                :ch4_emission_factor_units          => proc { AutomobileFuel.determine_fallback 'ch4_emission_factor_units' },
                :n2o_emission_factor                => proc { AutomobileFuel.determine_fallback 'n2o_emission_factor' },
                :n2o_emission_factor_units          => proc { AutomobileFuel.determine_fallback 'n2o_emission_factor_units' }
  
  warn_unless_size 12
  warn_if_blanks :code, :family, :distance_key
  warn_if do
    if exists?("name != 'electricity' AND base_fuel_name IS NULL")
      "Records missing #{col}"
    end
  end
  warn_if do
    if exists?(['blend_fuel_name IS NOT NULL AND (blend_portion IS NULL OR blend_portion <= ? OR blend_portion >= ?)', 0, 1])
      "Blend portions not between 0 and 1"
    end
  end
  warn_if do
    %w{annual_distance energy_content}.map do |col|
      if exists?(["#{col} IS NULL OR #{col} <= ?", 0])
        "Records not > 0 #{col}"
      end
    end
  end
  warn_if do
    %w{ co2_emission_factor co2_biogenic_emission_factor}.map do |col|
      if exists?(["name != 'electricity' AND (#{col} IS NULL OR #{col} < ?)", 0])
        "Records non-positive #{col}"
      end
    end
  end
  warn_if do
    %w{ch4_emission_factor n2o_emission_factor}.map do |col|
      if exists?(["#{col} IS NULL OR #{col} < ?", 0])
        "Records non-positive #{col}"
      end
    end
  end
end
