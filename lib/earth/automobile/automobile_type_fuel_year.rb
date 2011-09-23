class AutomobileTypeFuelYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :year_controls, :class_name => 'AutomobileTypeFuelYearControl', :foreign_key => 'type_fuel_year_name'
  belongs_to :type_year, :class_name => 'AutomobileTypeYear', :foreign_key => 'type_year_name'
  
  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :type_year_name
  col :total_travel, :type => :float
  col :total_travel_units
  col :fuel_consumption, :type => :float
  col :fuel_consumption_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  
  # %w{ type_name fuel_common_name type_year_name }.each do |attribute|
  #   verify "#{attribute.humanize} should never be missing" do
  #     AutomobileTypeFuelYear.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute.humanize.downcase} for AutomobileTypeFuelYear '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Year should be from 1990 to 2008" do
  #   AutomobileTypeFuelYear.all.each do |record|
  #     year = record.send(:year)
  #     unless year > 1989 and year < 2009
  #       raise "Invalid year for AutomobileTypeFuelYear '#{record.name}': #{year} (should be from 1990 to 2008)"
  #     end
  #   end
  # end
  # 
  # %w{ total_travel fuel_consumption ch4_emission_factor n2o_emission_factor }.each do |attribute|
  #   verify "#{attribute.humanize} should be greater than zero" do
  #     AutomobileTypeFuelYear.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYear '#{record.name}': #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # [["total_travel_units", "kilometres"],
  #  ["fuel_consumption_units", "litres"],
  #  ["ch4_emission_factor_units", "kilograms_per_litre"],
  #  ["n2o_emission_factor_units", "kilograms_per_litre"]].each do |pair|
  #   attribute = pair[0]
  #   proper_units = pair[1]
  #   verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
  #     AutomobileTypeFuelYear.all.each do |record|
  #       units = record.send(:"#{attribute}")
  #       unless units == proper_units
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYear '#{record.name}': #{units} (should be #{proper_units})"
  #       end
  #     end
  #   end
  # end
end
