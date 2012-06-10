require 'earth/eia'
require 'earth/locality/data_miner'

MecsRatio.class_eval do
  const_set(:CENSUS_REGIONS, {
    'Total US' =>  {
      :crop => (16..95),
      :code => nil
    },
    'Northeast' => {
      :crop => (100..179),
      :code => 1
    },
    'Midwest' => {
      :crop => (184..263),
      :code => 2
    },
    'South' =>  {
      :crop => (268..347),
      :code => 3
    },
    'West' => {
      :crop => (352..431),
      :code => 4
    }
  })
  
  data_miner do
    MecsRatio::CENSUS_REGIONS.each do |region, data|
      import( "MECS table 6.1 #{region}",
        :url => "http://www.eia.gov/emeu/mecs/mecs2006/excel/Table6_1.xls",
        :crop => data[:crop],
        :headers => ["NAICS Code", "Subsector and Industry", "Consumption per Employee", "Consumption per Dollar of Value Added", "Consumption per Dollar of Value of Shipments"]) do
        key :name, :synthesize => proc { |row| "#{Industry.format_naics_code(row["NAICS Code"])}-#{data[:code]}" }
        store :census_region_number, :static => data[:code]
        store :naics_code, :synthesize => proc { |row| Industry.format_naics_code row["NAICS Code"] }
        store :energy_per_dollar_of_shipments, :units => :megajoules, :synthesize => proc { |row|
          Earth::EIA.convert_value(row['Consumption per Dollar of Value of Shipments'], :from => :kbtus, :to => :megajoules)
        }
      end
    end
  end
end
