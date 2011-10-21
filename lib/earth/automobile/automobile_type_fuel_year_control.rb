class AutomobileTypeFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :type_name
  col :fuel_common_name
  col :year, :type => :integer
  col :control_name
  col :total_travel_percent, :type => :float
  
  # %w{ type_name fuel_common_name control_name type_fuel_control_name type_fuel_year_name }.each do |attribute|
  #   verify "#{attribute.humanize} should never be missing" do
  #     AutomobileTypeFuelYearControl.all.each do |record|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute.humanize.downcase} for AutomobileTypeFuelYearControl '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Year should be from 1990 to 2008" do
  #   AutomobileTypeFuelYearControl.all.each do |record|
  #     year = record.send(:year)
  #     unless year > 1989 and year < 2009
  #       raise "Invalid year for AutomobileTypeFuelYearControl '#{record.name}': #{year} (should be from 1990 to 2008)"
  #     end
  #   end
  # end
  
  # FIXME TODO verify "Total travel percent for each type fuel year should sum to one"
  
end
