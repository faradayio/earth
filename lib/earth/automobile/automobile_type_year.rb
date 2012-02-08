require 'earth/fuel'
class AutomobileTypeYear < ActiveRecord::Base
  self.primary_key = :name
  
  # FIXME TODO keep this until fix AutomobileFuel fallback hfc emission factor so that it doesn't call type_year.type_fuel_year
  has_many :type_fuel_years, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_year_name'
  
  col :name
  col :type_name
  col :year, :type => :integer
  col :hfc_emissions, :type => :float
  col :hfc_emissions_units
  col :hfc_emission_factor, :type => :float
  col :hfc_emission_factor_units
  
  # verify "Type name should never be missing" do
  #   AutomobileTypeYear.all.each do |record|
  #     value = record.send(:type_name)
  #     unless value.present?
  #       raise "Missing type name for AutomobileTypeYear '#{record.name}'"
  #     end
  #   end
  # end
  # 
  # verify "Year should be from 1990 to 2008" do
  #   AutomobileTypeYear.all.each do |record|
  #     year = record.send(:year)
  #     unless year > 1989 and year < 2009
  #       raise "Invalid year for AutomobileTypeYear '#{record.name}': #{year} (should be from 1990 to 2008)"
  #     end
  #   end
  # end
  # 
  # %w{ hfc_emissions hfc_emission_factor }.each do |attribute|
  #   verify "#{attribute.humanize} should be zero or more" do
  #     AutomobileTypeYear.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value >= 0
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeYear '#{record.name}': #{value} (should be zero or more)"
  #       end
  #     end
  #   end
  # end
  # 
  # [["hfc_emissions_units", "kilograms_co2e"], ["hfc_emission_factor_units", "kilograms_co2e_per_litre"]].each do |pair|
  #   attribute = pair[0]
  #   proper_units = pair[1]
  #   verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
  #     AutomobileTypeYear.all.each do |record|
  #       units = record.send(:"#{attribute}")
  #       unless units == proper_units
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeYear '#{record.name}': #{units} (should be #{proper_units})"
  #       end
  #     end
  #   end
  # end
  
end
