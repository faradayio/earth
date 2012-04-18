require 'earth/eia'
require 'earth/locality'

MecsEnergy.class_eval do
  const_set(:CENSUS_REGIONS, {
    'Total US' =>  {
      :crop => (15..94),
      :code => nil
    },
    'Northeast' => {
      :crop => (99..178),
      :code => 1
    },
    'Midwest' => {
      :crop => (183..262),
      :code => 2
    },
    'South' =>  {
      :crop => (267..346),
      :code => 3
    },
    'West' => {
      :crop => (351..430),
      :code => 4
    }
  })
  
  data_miner do
    MecsEnergy::CENSUS_REGIONS.each do |region, data|
      import("MECS table 3.2 #{region}",
        :url => "http://205.254.135.24/emeu/mecs/mecs2006/excel/Table3_2.xls",
        :crop => data[:crop],
        :headers => ["NAICS Code", "Subsector and Industry", "Total", "BLANK", "Net Electricity", "BLANK", "Residual Fuel Oil", "Distillate Fuel Oil", "Natural Gas", "BLANK", "LPG and NGL", "BLANK", "Coal", "Coke and Breeze", "Other"]) do
        key :name, :synthesize => proc { |row| "#{Industry.format_naics_code(row['NAICS Code'])}-#{data[:code]}" }
        store :census_region_number, :static => data[:code]
        store :naics_code, :field_name => 'NAICS Code'
        store :energy, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Total'], :from => :trillion_btus, :to => :megajoules)
        }
        store :electricity, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Net Electricity'], :from => :trillion_btus, :to => :megajoules)
        }
        store :residual_fuel_oil, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Residual Fuel Oil'], :from => :trillion_btus, :to => :megajoules)
        }
        store :distillate_fuel_oil, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Distillate Fuel Oil'], :from => :trillion_btus, :to => :megajoules)
        }
        store :natural_gas, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Natural Gas'], :from => :trillion_btus, :to => :megajoules)
        }
        store :lpg_and_ngl, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['LPG and NGL'], :from => :trillion_btus, :to => :megajoules)
        }
        store :coal, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Coal'], :from => :trillion_btus, :to => :megajoules)
        }
        store :coke_and_breeze, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Coke and Breeze'], :from => :trillion_btus, :to => :megajoules)
        }
        store :other_fuel, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Other'], :from => :trillion_btus, :to => :megajoules)
        }
      end
    end
  end
end
