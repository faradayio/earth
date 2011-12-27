require 'earth/eia'
require 'earth/locality/data_miner'
MecsRatio.class_eval do
  data_miner do
    MecsRatio::CENSUS_REGIONS.each do |region, data|
      import( "MECS table 6.1 #{region}",
        :url => "http://205.254.135.24/emeu/mecs/mecs2006/excel/Table6_1.xls",
        :crop => data[:crop]) do
        key 'name', :synthesize => Proc.new { |row| "#{Industry.format_naics_code(row[0])}-#{data[:code]}" }
        store 'naics_code', :synthesize => Proc.new { |row| Industry.format_naics_code row[0] }
        store 'consumption_per_dollar_of_shipments', :field_number => 4
        store 'census_region', :static => data[:code]
      end
    end

    process :normalize_fuels do
      Earth::EIA.normalize(MecsRatio, [:consumption_per_dollar_of_shipments])
    end
  end
end
