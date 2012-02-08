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
      61
    when /Food Sales/
      445
    when /Food Service/
      722
    when /Health Care/
      62
    when /Inpatient/
      622
    when /Outpatient/
      621
    when /Lodging/
      721 # FIXME TODO should really be 623, 62422, 721, maybe 8131
    when /Retail \(Other Than Mall\)/
      44 # FIXME TODO should really be 44 and 45 excluding 445 and 454
    when /Office/
      55 # Management of Companies and Enterprises
    when /Public Assembly/
      #TODO
    when /Public Order and Safety/
      922
    when /Religious Worship/
      8131
    when /Service/
      81 # other services (except public administration)
    when /Warehouse and Storage/
      493
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
        :select => ::Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
        :crop => (21..37) do
        key :name, :synthesize => ::Proc.new { |row| "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{data[:code]}" }
        store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER
        store :census_division_number, :static => data[:code]
        store :electricity, :synthesize => ::Proc.new { |row| Earth::EIA.convert_value({:value => row[data[:column] + 1], :from_units => :billion_kwh, :to_units => :kilowatt_hours}) }, :units => :kilowatt_hours
        store :floorspace, :synthesize => ::Proc.new { |row| Earth::EIA.convert_value({:value => row[data[:column] + 4], :from_units => :million_square_feet, :to_units => :square_metres}) }, :units => :square_metres
        store :electricity_intensity, :synthesize => ::Proc.new { |row| Earth::EIA.convert_value({:value => row[data[:column] + 7], :from_units => :kilowatt_hours_per_square_foot, :to_units => :kilowatt_hours_per_square_metre}) }, :units => :kilowatt_hours_per_square_metre
      end
    end
  end
end
