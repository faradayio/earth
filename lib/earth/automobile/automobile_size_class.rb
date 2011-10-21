class AutomobileSizeClass < ActiveRecord::Base
  set_primary_key :name
  
  # FIXME TODO clean up size class in MakeModelYearVariant, derive size class for MakeModelYear, and calculate this from MakeModelYear
  falls_back_on :hybrid_fuel_efficiency_city_multiplier => 1.651, # https://brighterplanet.sifterapp.com/issue/667
                :hybrid_fuel_efficiency_highway_multiplier => 1.213,
                :conventional_fuel_efficiency_city_multiplier => 0.987,
                :conventional_fuel_efficiency_highway_multiplier => 0.996
  
  col :name
  col :type_name
  col :annual_distance, :type => :float
  col :annual_distance_units
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  col :hybrid_fuel_efficiency_city_multiplier, :type => :float
  col :hybrid_fuel_efficiency_highway_multiplier, :type => :float
  col :conventional_fuel_efficiency_city_multiplier, :type => :float
  col :conventional_fuel_efficiency_highway_multiplier, :type => :float
  
  # FIXME TODO verify type_name?
  
  # verify "Annual distance should be greater than zero" do
  #   AutomobileSizeClass.all.each do |size_class|
  #     unless size_class.annual_distance > 0
  #       raise "Invalid annual distance for AutomobileSizeClass #{size_class.name}: #{size_class.annual_distance} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Annual distance units should be kilometres" do
  #   AutomobileSizeClass.all.each do |size_class|
  #     unless size_class.annual_distance_units == "kilometres"
  #       raise "Invalid annual distance units for AutomobileSizeClass #{size_class.name}: #{size_class.annual_distance_units} (should be kilometres)"
  #     end
  #   end
  # end
  # 
  #  verify "Fuel efficiencies should be greater than zero" do
  #   AutomobileSizeClass.all.each do |size_class|
  #     %w{ city highway }.each do |type|
  #       fuel_efficiency = size_class.send(:"fuel_efficiency_#{type}")
  #       unless fuel_efficiency > 0
  #         raise "Invalid fuel efficiency #{type} for AutomobileSizeClass #{size_class.name}: #{fuel_efficiency} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency units should be kilometres per litre" do
  #   AutomobileSizeClass.all.each do |size_class|
  #     %w{ city highway }.each do |type|
  #       units = size_class.send(:"fuel_efficiency_#{type}_units")
  #       unless units == "kilometres_per_litre"
  #         raise "Invalid fuel efficiency #{type} units for AutomobileSizeClass #{size_class.name}: #{units} (should be kilometres_per_litre)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Any fuel efficiency multipliers should be greater than zero" do
  #   AutomobileSizeClass.all.each do |size_class|
  #     %w{ hybrid conventional }.each do |hybridity|
  #       %w{ city highway }.each do |type|
  #         multiplier = size_class.send(:"#{hybridity}_fuel_efficiency_#{type}_multiplier")
  #         if multiplier.present?
  #           unless multiplier > 0
  #             raise "Invalid #{hybridity} fuel efficiency #{type} multiplier for AutomobileSizeClass #{size_class.name}: #{multiplier} (should be > 0)"
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fallback fuel efficiency multipliers should be greater than zero" do
  #   %w{ hybrid conventional }.each do |hybridity|
  #     %w{ city highway }.each do |type|
  #       multiplier = AutomobileSizeClass.fallback.send(:"#{hybridity}_fuel_efficiency_#{type}_multiplier")
  #       unless multiplier > 0
  #         raise "Invalid AutomobileSizeClass fallback #{hybridity} fuel efficiency #{type} multiplier: #{multiplier} (should be > 0)"
  #       end
  #     end
  #   end
  # end
end
