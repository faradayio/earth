require 'earth/eia'
require 'earth/locality/data_miner'

MecsRatio.class_eval do
  const_set(:CENSUS_REGIONS, {
    'Total US' =>  {
      :crop => (16..94),
      :code => nil
    },
    'Northeast' => {
      :crop => (100..178),
      :code => 1
    },
    'Midwest' => {
      :crop => (184..262),
      :code => 2
    },
    'South' =>  {
      :crop => (268..346),
      :code => 3
    },
    'West' => {
      :crop => (352..430),
      :code => 4
    }
  })
  
  data_miner do
    MecsRatio::CENSUS_REGIONS.each do |region, data|
      import( "MECS table 6.1 #{region}",
        :url => "http://205.254.135.24/emeu/mecs/mecs2006/excel/Table6_1.xls",
        :crop => data[:crop]) do
        key :name, :synthesize => Proc.new { |row| "#{Industry.format_naics_code(row[0])}-#{data[:code]}" }
        store :naics_code, :synthesize => Proc.new { |row| Industry.format_naics_code row[0] }
        store :consumption_per_dollar_of_shipments, :field_number => 4
        store :census_region, :static => data[:code]
      end
    end
    
    process :normalize_fuels do
      Earth::EIA.normalize(MecsRatio, [:consumption_per_dollar_of_shipments])
    end
  end
end
