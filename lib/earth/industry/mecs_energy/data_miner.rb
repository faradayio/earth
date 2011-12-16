require 'earth/eia'

MecsEnergy.class_eval do
  data_miner do
    MecsEnergy::CENSUS_REGIONS.each do |region, data|
      import("MECS table 3.2 #{region}",
        :url => "http://205.254.135.24/emeu/mecs/mecs2006/excel/Table3_2.xls",
        :crop => data[:crop]) do
        key 'name', :synthesize => Proc.new { |row| "#{Industry.format_naics_code(row[0])}-#{data[:code]}" }
        store 'naics_code', :field_number => 0
        store :total, :field_number => 2
        store :net_electricity, :field_number => 3
        store :residual_fuel_oil, :field_number => 4
        store :distillate_fuel_oil, :field_number => 5
        store :natural_gas, :field_number => 6
        store :lpg_and_ngl, :field_number => 7
        store :coal, :field_number => 8
        store :coke_and_breeze, :field_number => 9
        store :other, :field_number => 10
        store 'census_region', :static => data[:code]
      end
    end

    process :normalize_fuels do
      Earth::EIA.normalize(MecsEnergy, FUELS)
    end
  end
end
