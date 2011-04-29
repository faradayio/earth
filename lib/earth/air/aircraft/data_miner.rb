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
    
    # process "Derive some average aircraft characteristics from flight segments" do
    #   FlightSegment.run_data_miner!
    #   aircraft = Aircraft.arel_table
    #   segments = FlightSegment.arel_table
    #   
    #   # FIXME TODO
    #   # This should calculate weighted averages from flight segments
    #   # For example, to calculate seats:
    #   # SELECT aircraft.icao_code, sum(flight_segments.seats * flight_segments.passengers) / sum(flight_segments.passengers)
    #   # FROM flight_segments
    #   # INNER JOIN aircraft_aircraft_types ON flight_segments.aircraft_type_code = aircraft_aircraft_types.aircraft_type_code
    #   # INNER JOIN aircraft ON aircraft_aircraft_types.icao_code = aircraft.icao_code
    #   # GROUP BY aircraft.icao_code
    #   
    #   conditional_relation = segments[:aircraft_bts_code].eq(aircraft[:bts_code])
    #   update_all "seats = (#{FlightSegment.weighted_average_relation(:seats, :weighted_by => :passengers).where(conditional_relation).to_sql})"
    #   update_all "weighting = (#{segments.project(segments[:passengers].sum).where(conditional_relation).to_sql})"
    #   
    #   # conditional_relation = aircraft[:aircraft_type_code].eq(segments[:aircraft_type_code])
    #   
    #   # update_all "seats         = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
    #   
    #   # update_all "distance      = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
    #   # update_all "load_factor   = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
    #   # update_all "freight_share = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
    #   # update_all "payload       = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).where(conditional_relation).to_sql})"
    #   
    #   # update_all "weighting = (#{segments.project(segments[:passengers].sum).where(aircraft[:aircraft_type_code].eq(segments[:aircraft_type_code])).to_sql})"
    # end
    
    # FIXME TODO verify this
  end
end
