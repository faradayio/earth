# Not yet in use - for if we want to autocaculate size class stuf - November 10, 2011
class AutomobileSizeClassYear < ActiveRecord::Base
  set_primary_key :name

  col :name
  col :size_class_name
  col :year, :type => :integer
  col :type_name
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  
  # verify "Year should be from 1975 to 2010" do
  #   AutomobileSizeClassYear.all.each do |record|
  #     unless record.year > 1974 and record.year < 2011
  #       raise "Invalid year for AutomobileSizeClassYear #{record.name}: #{record.year} (should be from 1975 to 2010)"
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiencies should be greater than zero" do
  #   AutomobileSizeClassYear.all.each do |year|
  #     %w{ fuel_efficiency_city fuel_efficiency_highway }.each do |attribute|
  #       value = year.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute} for AutomobileSizeClassYear #{year.name}: #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency units should be kilometres per litre" do
  #   AutomobileSizeClassYear.all.each do |year|
  #     %w{ fuel_efficiency_city_units fuel_efficiency_highway_units }.each do |attribute|
  #       value = year.send(:"#{attribute}")
  #       unless value == "kilometres_per_litre"
  #         raise "Invalid #{attribute} for AutomobileSizeClassYear #{year.name}: #{value} (should be kilometres_per_litre)"
  #       end
  #     end
  #   end
  # end
end
