require 'earth/model'

require 'earth/fuel/fuel_year'

class Fuel < ActiveRecord::Base
  data_miner do
    process "Data mine FuelYear because some methods are delegated to it" do
      FuelYear.run_data_miner!
    end
  end
  
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "fuels"
  (
     "name"                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "physical_units"                     CHARACTER VARYING(255),
     "density"                            FLOAT,
     "density_units"                      CHARACTER VARYING(255),
     "energy_content"                     FLOAT,
     "energy_content_units"               CHARACTER VARYING(255),
     "carbon_content"                     FLOAT,
     "carbon_content_units"               CHARACTER VARYING(255),
     "oxidation_factor"                   FLOAT,
     "biogenic_fraction"                  FLOAT,
     "co2_emission_factor"                FLOAT,
     "co2_emission_factor_units"          CHARACTER VARYING(255),
     "co2_biogenic_emission_factor"       FLOAT,
     "co2_biogenic_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :fuel_years, :foreign_key => 'fuel_name'
  
  def latest_fuel_year
    fuel_years.find_by_year fuel_years.maximum(:year)
  end
  
  [
    :energy_content,
    :energy_content_units,
    :carbon_content,
    :carbon_content_units,
    :oxidation_factor,
    :biogenic_fraction,
    :co2_emission_factor,
    :co2_emission_factor_units,
    :co2_biogenic_emission_factor,
    :co2_biogenic_emission_factor_units
  ].each do |method_name|
    define_method method_name do
      if attribute = super()
        attribute
      elsif fuel_years.present?
        latest_fuel_year.send method_name
      end
    end
  end
  
  warn_unless_size 23
end
