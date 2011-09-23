class GreenhouseGas < ActiveRecord::Base
  set_primary_key :name
    
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
  
  col :name
  col :abbreviation
  col :ipcc_report
  col :time_horizon, :type => :integer
  col :time_horizon_units
  col :global_warming_potential, :type => :integer
  
  # verify "Abbreviation and IPCC report should never be missing" do
  #   GreenhouseGas.all.each do |record|
  #     %w{ abbreviation ipcc_report }.each do |attribute|
  #       value = record.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute} for GreenhouseGas '#{record.name}'"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Time horizon should be 100" do
  #   GreenhouseGas.all.each do |record|
  #     value = record.send(:time_horizon)
  #     unless value == 100
  #       raise "Invalid time horizon for GreenhouseGas '#{record.name}': #{value} (should be 100)"
  #     end
  #   end
  # end
  # 
  # verify "Time horizon units should be years" do
  #   GreenhouseGas.all.each do |record|
  #     units = record.send(:time_horizon_units)
  #     unless units == "years"
  #       raise "Invalid time horizon units for GreenhouseGas '#{record.name}': #{units} (should be years)"
  #     end
  #   end
  # end
  # 
  # verify "Global warming potential should be one or more" do
  #   GreenhouseGas.all.each do |record|
  #     value = record.send(:global_warming_potential)
  #     unless value >= 1
  #       raise "Invalid global warming potential for GreenhouseGas '#{record.name}': #{value} (should >= 1)"
  #     end
  #   end
  # end
  
end