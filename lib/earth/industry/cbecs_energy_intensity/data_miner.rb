require 'earth/eia'
require 'earth/locality/data_miner'
CbecsEnergyIntensity.class_eval do
  const_set(:CENSUS_DIVISIONS, {
    'New England Division' => {
      :column => 0,
      :code => 1,
      :table => 'c17'
    },
    'Middle Atlantic Division' => {
      :column => 1,
      :code => 2,
      :table => 'c17'
    },
    'East North Central Division' => {
      :column => 2,
      :code => 3,
      :table => 'c17'
    },
    'West North Central Division' => {
      :column => 0,
      :code => 4,
      :table => 'c18'
    },
    'South Atlantic Division' => {
      :column => 1,
      :code => 5,
      :table => 'c18'
    },
    'East South Central Division' => {
      :column => 2,
      :code => 6,
      :table => 'c18'
    },
    'West South Central Division' => {
      :column => 0,
      :code => 7,
      :table => 'c19'
    },
    'Mountain Division' => {
      :column => 1,
      :code => 8,
      :table => 'c19'
    },
    'Pacific Division' => {
      :column => 2,
      :code => 9,
      :table => 'c19'
    }
  })
  
  const_set(:NAICS_CODE_SYNTHESIZER, lambda { |row|
    case row[0].to_s
    when /Education/
      611110
    when /Food Sales/
      445
    when /Food Service/
      722
    when /Health Care/
      622110
    when /Inpatient/
      622110
    when /Outpatient/
      622111
    when /Lodging/
      721
    when /Retail (Other Than Mall)/
      44
    when /Office/
      #TODO
    when /Public Assembly/
      #TODO
    when /Public Order and Safety/
      922120
    when /Religious Worship/
      813110
    when /Service/
      #TODO
    when /Warehouse and Storage/
      493110
    when /Other/
      #TODO
    when /Vacant/
      #TODO
    end
  })
  
  data_miner do
    CbecsEnergyIntensity::CENSUS_DIVISIONS.each do |division, data|
      import "2003 CBECS #{data[:table].upcase} - Electricity Consumption and Intensity - #{division}",
        :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/#{data[:table]}.xls",
        :headers => false,
        :select => ::Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) },
        :crop => (21..37) do
        key :name, :synthesize => ::Proc.new { |row| "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{data[:code]}" }
        store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER
        store :census_division_number, :static => data[:code]
        store :total_electricity_consumption, :field_number => data[:column] + 1
        store :total_floorspace, :field_number => data[:column] + 4
        store :electricity_intensity, :field_number => data[:column] + 7
      end
    end

    process :normalize_fuels do
      Earth::EIA.normalize(CbecsEnergyIntensity, [:total_electricity_consumption, :total_floorspace, :electricity_intensity])
    end
  end
end
