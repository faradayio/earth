class AutomobileTypeFuelYearAge < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :type_fuel_year, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_fuel_year_name'

  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :age, :type => :integer
  col :type_fuel_year_name
  col :total_travel_percent, :type => :float
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :vehicles, :type => :integer
  
  # %w{ type_name fuel_common_name type_fuel_year_name}.each do |attribute|
  #   verify "#{attribute.humanize} should never be missing" do
  #     AutomobileTypeFuelYearAge.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Year should be 2008" do
  #   AutomobileTypeFuelYearAge.all.each do |record|
  #     value = record.send(:year)
  #     unless value == 2008
  #       raise "Invalid year for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be 2008)"
  #     end
  #   end
  # end
  # 
  # [["age", 0, 30], ["total_travel_percent", 0, 1]].each do |triplet|
  #   attribute = triplet[0]
  #   min = triplet[1]
  #   max = triplet[2]
  #   verify "#{attribute.humanize} should be from #{min} to #{max}" do
  #     AutomobileTypeFuelYearAge.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value >= min and value <= max
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be from #{min} to #{max})"
  #       end
  #     end
  #   end
  # end
  # 
  # %w{ annual_distance vehicles }.each do |attribute|
  #   verify "#{attribute.humanize} should be greater than zero" do
  #     AutomobileTypeFuelYearAge.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Annual distance units should be kilometres" do
  #   AutomobileTypeFuelYearAge.all.each do |record|
  #     units = record.send(:annual_distance_units)
  #     unless units == "kilometres"
  #       raise "Invalid annual distance units for AutomobileTypeFuelYearAge '#{record.name}': #{units} (should be kilometres)"
  #     end
  #   end
  # end
end
