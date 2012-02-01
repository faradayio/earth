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
        key :name, :synthesize => Proc.new { |row| "#{Industry.format_naics_code(row['NAICS Code'])}-#{data[:code]}" }
        store :census_region_number, :static => data[:code]
        store :naics_code, :field_name => 'NAICS Code'
        store :energy,              :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Total'],               :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :electricity,         :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Net Electricity'],     :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :residual_fuel_oil,   :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Residual Fuel Oil'],   :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :distillate_fuel_oil, :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Distillate Fuel Oil'], :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :natural_gas,         :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Natural Gas'],         :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :lpg_and_ngl,         :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['LPG and NGL'],         :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :coal,                :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Coal'],                :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :coke_and_breeze,     :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Coke and Breeze'],     :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
        store :other_fuel,          :synthesize => Proc.new { |row| Earth::EIA.convert_value({:value => row['Other'],               :from_units => :trillion_btus, :to_units => :megajoules}) }, :units => :megajoules
      end
    end
  end
end
