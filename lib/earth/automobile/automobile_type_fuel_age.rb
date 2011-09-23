# DEPRECATED - use AutomobileTypeFuelYearAge
class AutomobileTypeFuelAge < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :type_name
  col :fuel_common_name
  col :age, :type => :integer
  col :age_percent, :type => :float
  col :total_travel_percent, :type => :float
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :vehicles, :type => :integer
  
  # verify "Type name and fuel common name should never be missing" do
  #   AutomobileTypeFuelAge.all.each do |record|
  #     %w{ type_name fuel_common_name }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute} for AutomobileTypeFuelAge '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Age should be from zero to thirty" do
  #   AutomobileTypeFuelAge.all.each do |record|
  #     value = record.send(:age)
  #     unless value >= 0 and value < 31
  #       raise "Invalid age for AutomobileTypeFuelAge '#{record.name}': #{value} (should be from 0 to 30)"
  #     end
  #   end
  # end
  # 
  # verify "Age percent and total travel percent should be from zero to one" do
  #   AutomobileTypeFuelAge.all.each do |record|
  #     %w{ age_percent total_travel_percent }.each do |attribute|
  #       percent = record.send(:"#{attribute}")
  #       unless percent > 0 and percent < 1
  #         raise "Invalid #{attribute} for AutomobileTypeFuelAge '#{record.name}': #{percent} (should be from 0 to 1)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Annual distance and vehicles should be greater than zero" do
  #   AutomobileTypeFuelAge.all.each do |record|
  #     %w{ annual_distance vehicles }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute} for AutomobileTypeFuelAge '#{record.name}': #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Annual distance units should be kilometres" do
  #   AutomobileTypeFuelAge.all.each do |record|
  #     units = record.send(:annual_distance_units)
  #     unless units == "kilometres"
  #       raise "Invalid annual distance units for AutomobileTypeFuelAge '#{record.name}': #{units} (should be kilometres)"
  #     end
  #   end
  # end
end
