Aircraft.class_eval do
  # For errata
  class Aircraft::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A([a-z]+)_is_n?o?t?_?([^\?]+)/
        column_name = $1
        value = $2
        value_regexp = Regexp.new('^' + value.gsub('_', ' ') + '$', Regexp::IGNORECASE)
        matches = value_regexp.match(args.first[column_name.titleize]) # row['Manufacturer'] =~ /mcdonnell douglas/i
        method_id.to_s.include?('_not_') ? matches.nil? : !matches.nil?
      else
        super
      end
    end
  end
  
  # We're only interested in aircraft from certain manufacturers
  def self.manufacturer_whitelist?(candidate)
    @manufacturer_whitelist ||= RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFRFalpOdlg1cnF6amlSM1dDc1lya2c&output=csv')
    @manufacturer_whitelist.any? { |record| record['Manufacturer'].to_regexp.match(candidate) }
  end
  
  data_miner do
    schema Earth.database_options do
      string  'icao_code'
      string  'manufacturer_name'
      string  'model_name'
      string  'description'
      string  'aircraft_type'
      string  'engine_type'
      integer 'engines'
      string  'weight_class'
      string  'class_code'
      string  'fuel_use_code'
      float   'seats'
      float   'passengers'
    end
    
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
    
    import "a curated list of aircraft fuel use codes",
           :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGxqRjFJdDlQWVVLYS11NnJVcDZsYWc&output=csv' do
      key 'icao_code'
      store 'fuel_use_code'
    end
    
    process "Synthesize description from manufacturer name and model name" do
      Aircraft.find_each do |aircraft|
        aircraft.description = [aircraft.manufacturer_name, aircraft.model_name].join(" ").downcase
        aircraft.save
      end
    end
    
    process "Synthesize class code from engine type and weight class" do
      Aircraft.find_each do |aircraft|
        if aircraft.weight_class == "Small" or aircraft.weight_class == "Small+" or aircraft.weight_class == "Light"
          size = "Light"
        elsif aircraft.weight_class == "Large" or aircraft.weight_class == "Medium"
          size = "Medium"
        else
          size = "Heavy"
        end
        aircraft.class_code = [size, aircraft.engines.to_s, "engine", aircraft.engine_type].join(" ")
        aircraft.save
      end
    end
    
    process "Ensure FlightSegment is populated" do
      FlightSegment.run_data_miner!
    end
    
    process "Derive some average characteristics from flight segments" do
      Aircraft.find_each do |aircraft|
        aircraft.seats = aircraft.flight_segments.weighted_average(:seats_per_flight, :weighted_by => :passengers)
        aircraft.passengers = aircraft.flight_segments.sum(:passengers)
        aircraft.save
      end
    end
    
    # FIXME TODO verify this
  end
end
