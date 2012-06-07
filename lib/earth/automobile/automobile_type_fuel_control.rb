require 'earth/fuel'
class AutomobileTypeFuelControl < ActiveRecord::Base
  self.primary_key = "name"
  col :name
  col :type_name
  col :fuel_common_name
  col :control_name
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  
  # verify "Type name, fuel common name, and control name should never be missing" do
  #   AutomobileTypeFuelControl.all.each do |record|
  #     %w{ type_name fuel_common_name control_name }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute} for AutomobileTypeFuelControl '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Emission factors should be greater than zero" do
  #   AutomobileTypeFuelControl.all.each do |record|
  #     %w{ ch4_emission_factor n2o_emission_factor }.each do |factor|
  #       value = record.send(:"#{factor}")
  #       unless value > 0
  #         raise "Invalid #{factor} for AutomobileTypeFuelControl '#{record.name}': #{valuel} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Emission factor units should be kilograms per kilometre" do
  #   AutomobileTypeFuelControl.all.each do |record|
  #     %w{ ch4_emission_factor_units n2o_emission_factor_units }.each do |attribute|
  #       units = record.send(:"#{attribute}")
  #       unless units == "kilograms_per_kilometre"
  #         raise "Invalid #{attribute} for AutomobileTypeFuelControl '#{record.name}': #{units} (should be kilograms_per_kilometre)"
  #       end
  #     end
  #   end
  # end

  warn_unless_size 20
end
