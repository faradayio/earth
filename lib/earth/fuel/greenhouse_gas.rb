require 'earth/model'

class GreenhouseGas < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE greenhouse_gases
  (
     name                     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     abbreviation             CHARACTER VARYING(255),
     ipcc_report              CHARACTER VARYING(255),
     time_horizon             INTEGER,
     time_horizon_units       CHARACTER VARYING(255),
     global_warming_potential INTEGER
  );

EOS

  self.primary_key = "name"
    
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
  
  
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
  

  warn_unless_size 4
end
