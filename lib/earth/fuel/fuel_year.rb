require 'earth/model'

require 'earth/fuel/fuel'

class FuelYear < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "fuel_years"
  (
     "name"                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "fuel_name"                          CHARACTER VARYING(255),
     "year"                               INTEGER,
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
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  
  
  # FIXME TODO verify fuel name is in Fuel
  # verify "Fuel name should never be missing" do
  #   FuelYear.all.each do |record|
  #     fuel_name = record.send(:fuel_name)
  #     if fuel_name.nil?
  #       raise "Missing fuel name for FuelYear '#{record.name}'"
  #     end
  #   end
  # end
  # 
  # verify "Year should be from 1990 to 2008" do
  #   FuelYear.all.each do |record|
  #     year = record.send(:year)
  #     unless year > 1989 and year < 2009
  #       raise "Invalid year for FuelYear '#{record.name}': #{year} (should be from 1990 to 2008)"
  #     end
  #   end
  # end
  # 
  # verify "Carbon content and energy content should be greater than zero" do
  #   FuelYear.all.each do |record|
  #     %w{ carbon_content energy_content }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute} for FuelYear '#{record.name}': #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Emission factors should be zero or more" do
  #   FuelYear.all.each do |record|
  #     %w{ co2_emission_factor co2_biogenic_emission_factor }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value >= 0
  #         raise "Invalid #{attribute} for FuelYear '#{record.name}': #{value} (should be >= 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # FIXME TODO verify units

  warn_unless_size 171
end
