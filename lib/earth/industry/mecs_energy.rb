class MecsEnergy < ActiveRecord::Base
  col :name
  col :census_region
  col :naics_code
  col :total, :type => :float
  col :net_electricity, :type => :float
  col :residual_fuel_oil, :type => :float
  col :distillate_fuel_oil, :type => :float
  col :natural_gas, :type => :float
  col :lpg_and_ngl, :type => :float
  col :coal, :type => :float
  col :coke_and_breeze, :type => :float
  col :other, :type => :float

  CENSUS_REGIONS = {
    'Total US' =>  {
      :crop => (13..81),
      :code => nil
    },
    'Northeast' => {
      :crop => (88..156),
      :code => 1
    },
    'Midwest' => {
      :crop => (163..231),
      :code => 2
    },
    'South' =>  {
      :crop => (238..306),
      :code => 3
    },
    'West' => {
      :crop => (313..382),
      :code => 4
    }
  }

  FUELS = [:net_electricity, :residual_fuel_oil, :distillate_fuel_oil,
           :natural_gas, :lpg_and_ngl, :coal, :coke_and_breeze, :other]

  def self.find_by_naics_code_and_census_region(code, census_region)
    if code.blank?
      record = nil 
    else
      code = Industry.format_naics_code code
      record = where('census_region = ? AND naics_code LIKE ?', census_region, "#{code}%").first
      record ||= find_by_naics_code_and_census_region(code[0..-2], census_region)
    end
    record
  end

  def fuel_ratios
    FUELS.inject({}) do |ratios, fuel|
      ratios[fuel] = send(fuel).to_f / total.to_f
      ratios
    end
  end
end
