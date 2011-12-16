CbecsEnergyIntensity.class_eval do
  data_miner do
    NAICS_CODE_SYNTHESIZER = Proc.new do |row|
      case row[0].gsub(/\./, '')
      when 'Education' then
        611110
      when 'Food Sales' then
        445
      when 'Food Service' then
        722
      when 'Health Care' then
        622110
      when 'Inpatient' then
        622110
      when 'Outpatient' then
        622111
      when 'Lodging' then
        721
      when 'Retail (Other Than Mall)' then
        44
      when 'Office' then
        #TODO
      when 'Public Assembly' then
        #TODO
      when 'Public Order and Safety' then
        922120
      when 'Religious Worship' then
        813110
      when 'Service' then
        #TODO
      when 'Warehouse and Storage' then
        493110
      when 'Other' then
        #TODO
      when 'Vacant' then
        #TODO
      end
    end

    CbecsEnergyIntensity::CENSUS_DIVISIONS.each do |division, data|
      import "2003 CBECS #{data[:table].capitalize} - Electricity Consumption and Intensity - #{division}",
        :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/#{data[:table]}.xls",
        :crop => (21..36) do
        key :name, :synthesize => Proc.new { |row| "#{Industry.format_naics_code(row[0])}-#{data[:code]}" }
        store :naics_code, :synthesize =>  NAICS_CODE_SYNTHESIZER
        store :census_division_number, :static => data[:code]
        store :total_electricity_consumption, :field_number => data[:column] + 1
        store :total_floorspace, :field_number => data[:column] + 4
        store :electricity_intensity, :field_number => data[:column] + 7
      end
    end

    process :normalize_fuels do
      EIA.normalize(CbecsEnergyIntensity, [:total_electricity_consumption, :total_floorspace, :electricity_intensity])
    end
  end
end
