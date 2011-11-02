Aircraft.class_eval do
  # For errata
  class Aircraft::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A([a-z]+)_is_(?:not_)?([^\?]+)/
        column_name = $1
        value = $2
        value_regexp = /^#{value.gsub('_',' ')}$/i
        # row['Manufacturer'] =~ /mcdonnell douglas/i
        matches = value_regexp.match(args.first[column_name.titleize])
        method_id.to_s.include?('_not_') ? matches.nil? : !matches.nil?
      else
        super
      end
    end
  end
  
  # We're only interested in aircraft from certain manufacturers
  def self.manufacturer_whitelist?(candidate)
    @manufacturer_whitelist ||= RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFRFalpOdlg1cnF6amlSM1dDc1lya2c&output=csv').map { |record| record['Manufacturer'].to_regexp }
    @manufacturer_whitelist.any? { |manufacturer_regexp| manufacturer_regexp.match candidate }
  end
  
  data_miner do
    ('A'..'Z').each do |letter|
      import("aircraft made by whitelisted manufacturers whose ICAO code starts with '#{letter}' from the FAA",
             :url => "http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-#{letter}.htm",
             :encoding => 'windows-1252',
             :row_xpath => '//table/tr[2]/td/table/tr',
             :column_xpath => 'td',
             :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGVBRnhkRGhSaVptSDJ5bXJGbkpUSWc&output=csv', :responder => Aircraft::Guru.new },
             :select => lambda { |record| manufacturer_whitelist? record['Manufacturer'] }) do
        key 'icao_code',           :field_name => 'Designator'
        store 'manufacturer_name', :field_name => 'Manufacturer'
        store 'model_name',        :field_name => 'Model'
        store 'aircraft_type',     :field_name => 'Type/Wt Class', :chars => 0, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDJtU0stS0duR1NhQVVIU29valYwREE&output=csv'}
        store 'engine_type',       :field_name => 'Type/Wt Class', :chars => 2, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHgtS0xRTERpbjAxSzBBNFc4LUJEMXc&output=csv'}
        store 'engines',           :field_name => 'Type/Wt Class', :chars => 1
        store 'weight_class',      :field_name => 'Type/Wt Class', :split => { :pattern => %r{/}, :keep => 1 }, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGhrWElDZ25oV2NPREg0eUhjRVRYUHc&output=csv'}
      end
    end
    
    import "aircraft not included in the FAA database",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRNaVpSUWw2Z2VhN3RUV25yYWdQX2c&output=csv' do
      key 'icao_code'
      store 'manufacturer_name'
      store 'model_name'
      store 'aircraft_type'
      store 'engine_type'
      store 'engines'
      store 'weight_class'
    end
    
    import "aircraft fuel use equations derived from EMEP/EEA and ICAO",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdEhYenF3dGt1T0Y1cTdneUNsNjV0dEE&output=csv' do
      key 'icao_code'
      store 'm3', :units_field_name => 'm3_units'
      store 'm2', :units_field_name => 'm2_units'
      store 'm1', :units_field_name => 'm1_units'
      store 'b',  :units_field_name => 'b_units'
      store 'fuel_use_specificity', :static => 'aircraft'
    end
    
    process "Synthesize description from manufacturer name and model name" do
      find_each do |aircraft|
        aircraft.update_attribute :description, [aircraft.manufacturer_name, aircraft.model_name].join(' ').downcase
      end
    end
    
    process "Synthesize class code from engine type and weight class" do
      find_each do |aircraft|
        size = case aircraft.weight_class
        when 'Small', 'Small+', 'Light'
          'Light'
        when 'Large', 'Medium'
          'Medium'
        else
          'Heavy'
        end
        aircraft.update_attribute :class_code, [size, aircraft.engines.to_s, 'engine', aircraft.engine_type].join(' ')
      end
    end
    
    # Calculate seats and passengers from flight_segments
    process :update_averages!
    
    # Calculate missing seats and fuel use coefficients from other aircraft in same aircraft class
    process :derive_missing_values!
  end
end
