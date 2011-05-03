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
  
  # For manufacturer whitelist
  class String
    REGEXP_DELIMITERS = {
      '%r{' => '}',
      '/' => '/'
    }
    
    def to_regexp
      str = self.dup
      delim_start, delim_end = REGEXP_DELIMITERS.detect { |k, v| str.start_with? k }.map { |delim| ::Regexp.escape delim }
      %r{\A#{delim_start}(.*)#{delim_end}([^#{delim_end}]*)\z} =~ str.strip
      content = $1
      options = $2
      content.gsub! '\\/', '/'
      ignore_case = options.include?('i') ? ::Regexp::IGNORECASE : nil
      multiline = options.include?('m') ? ::Regexp::MULTILINE : nil
      extended = options.include?('x') ? ::Regexp::EXTENDED : nil
      ::Regexp.new content, (ignore_case||multiline||extended)
    end
  end
  
  # For manufacturer whitelist
  class Regexp
    def to_regexp
      dup
    end
  end
  
  # We're only interested in aircraft from certain manufacturers
  def self.manufacturer_whitelist?(candidate)
    @manufacturer_whitelist ||= RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFRFalpOdlg1cnF6amlSM1dDc1lya2c&output=csv')
    @manufacturer_whitelist.any? { |record| record['Manufacturer'].to_regexp.match(candidate) }
  end
  
  data_miner do
    schema Earth.database_options do
      string 'icao_code'
      string 'manufacturer_name'
      string 'model_name'
      string 'aircraft_type'
      string 'engine_type'
      float  'engines'
      string 'weight_class'
      string 'class_code'
      string 'fuel_use_code'
      float  'seats'
      float  'passengers'
    end
    
    ('A'..'Z').each do |letter|
      import "aircraft made by whitelisted manufacturers whose ICAO code starts with '#{letter}' from the FAA",
             :url => "http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-#{letter}.htm",
             :encoding => 'windows-1252',
             :row_xpath => '//table/tr[2]/td/table/tr',
             :column_xpath => 'td',
             :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGVBRnhkRGhSaVptSDJ5bXJGbkpUSWc&output=csv',
                          :responder => Aircraft::Guru.new },
             :select => lambda { |record| manufacturer_whitelist? record['Manufacturer'] } do
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
    
    process "Synthesize aircraft class code from engine type and weight class" do
      Aircraft.all.each do |aircraft|
        if aircraft.weight_class == "Small" or aircraft.weight_class == "Small+" or aircraft.weight_class == "Light"
          size = "Light"
        elsif aircraft.weight_class == "Large" or aircraft.weight_class == "Medium"
          size = "Medium"
        else
          size = "Heavy"
        end
        aircraft.class_code = size + ' ' + aircraft.engine_type
        aircraft.save
      end
    end
    
    process "Derive some average aircraft characteristics from flight segments" do
      FlightSegment.run_data_miner!
      Aircraft.all.each do |aircraft|
        aircraft.seats = flight_segments.weighted_average(:seats, :weighted_by => :passengers)
        aircraft.passengers = flight_segments.sum(:passengers)
        aircraft.save
      end
    end
    
    # FIXME TODO verify this
  end
end
