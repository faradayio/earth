require 'earth/locality'

class MecsEnergy < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :census_region_number, :type => :integer
  col :naics_code
  col :energy, :type => :float
  col :energy_units
  col :electricity, :type => :float
  col :electricity_units
  col :residual_fuel_oil, :type => :float
  col :residual_fuel_oil_units
  col :distillate_fuel_oil, :type => :float
  col :distillate_fuel_oil_units
  col :natural_gas, :type => :float
  col :natural_gas_units
  col :lpg_and_ngl, :type => :float
  col :lpg_and_ngl_units
  col :coal, :type => :float
  col :coal_units
  col :coke_and_breeze, :type => :float
  col :coke_and_breeze_units
  col :other_fuel, :type => :float
  col :other_fuel_units
  
  FUELS = [:electricity, :residual_fuel_oil, :distillate_fuel_oil,
           :natural_gas, :lpg_and_ngl, :coal, :coke_and_breeze, :other_fuel]
  
   # Find the first record whose naics_code matches code and that has valid fuel ratios.
   # If no record found chop off the last character of code and try again, and so on.
   def self.find_by_naics_code(code)
     find_by_naics_code_and_census_region_number(code, nil)
   end
   
   # Find the first record whose census_region_number matches number, whose naics_code matches code, and that has valid fuel ratios.
   # If none found and we know census region number, try looking nationwide
   # If none found and looking nationwide, chop off the last character of code and try again looking in census region
   # And so on
  def self.find_by_naics_code_and_census_region_number(code, number, original_number = number)
    if code.blank?
      record = nil
    else
      code = Industry.format_naics_code code
      candidate = where(:census_region_number => number, :naics_code => code).first
      
      if candidate.try(:fuel_ratios).present?
        record = candidate
      elsif number.present?
        record = find_by_naics_code_and_census_region_number(code, nil, original_number)
      else
        record = find_by_naics_code_and_census_region_number(code[0..-2], original_number)
      end
    end
    record
  end
  
  def fuel_ratios
    # Don't return a ratio if reported total energy was withheld
    if energy.to_f > 0
      # Calculate the sum of all fuels and note if any were withheld
      withheld = 0
      fuels_sum = MecsEnergy::FUELS.inject(0) do |sum, fuel|
        (value = send("#{fuel}")).nil? ? withheld = 1 : sum += value
        sum
      end
      
      # If energy > sum of all fuels and some fuels were withheld, calculate fuel ratios as fraction of energy
      # and attribute the disparity between energy and sum of all fuels to the dirtiest fuel that was withheld
      if energy > fuels_sum and withheld == 1
        ratios = MecsEnergy::FUELS.inject({}) do |r, fuel|
          fuel_use = send("#{fuel}")
          r[fuel] = fuel_use.present? ? fuel_use / energy : nil
          r
        end
        
        dirtiest_withheld = ([:coal, :other_fuel, :coke_and_breeze, :residual_fuel_oil, :distillate_fuel_oil, :lpg_and_ngl, :natural_gas] & ratios.select{|k,v| v.nil?}.keys).first
        ratios[dirtiest_withheld] = (energy - fuels_sum) / energy
        ratios.delete_if{ |fuel, ratio| ratio.to_f == 0.0 }
      # Otherwise calculate ratios as fraction of sum of all fuels, skipping any fuels that were withheld
      else
        ratios = MecsEnergy::FUELS.inject({}) do |r, fuel|
          fuel_use = send("#{fuel}")
          r[fuel] = fuel_use / fuels_sum if fuel_use.to_f > 0
          r
        end
        ratios.keys.any? ? ratios : nil
      end
    end
  end
end
