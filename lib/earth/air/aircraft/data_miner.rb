Aircraft.class_eval do
  # def self.bts_name_dictionary
  #   @_bts_dictionary ||= LooseTightDictionary.new RemoteTable.new(:url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE', :select => lambda { |record| record['Code'].to_i.between?(1, 998) }),
  #                                                 :tightenings  => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=0&output=csv', :headers => false),
  #                                                 :identities   => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=3&output=csv', :headers => false),
  #                                                 :blockings    => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=4&output=csv', :headers => false),
  #                                                 :blocking_only => true,
  #                                                 :right_reader => lambda { |record| record['Description'] }
  # end
  # 
  # # warning: self-referential, assumes it will be used once first import step is done
  # def self.icao_name_dictionary
  #   @_icao_dictionary ||= LooseTightDictionary.new Aircraft.all,
  #                                                  :tightenings  => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=0&output=csv', :headers => false),
  #                                                  :identities   => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=3&output=csv', :headers => false),
  #                                                  :blockings    => RemoteTable.new(:url => 'http://spreadsheets.google.com/pub?key=tiS_6CCDDM_drNphpYwE_iw&single=true&gid=4&output=csv', :headers => false),
  #                                                  :right_reader => lambda { |record| record.manufacturer_name.to_s + ' ' + record.name.to_s }
  # end
  # 
  # class Aircraft::BtsMatcher
  #   attr_reader :wants
  #   def initialize(wants)
  #     @wants = wants
  #   end
  #   def match(raw_faa_icao_record)
  #     @_match ||= Hash.new
  #     return @_match[raw_faa_icao_record] if @_match.has_key?(raw_faa_icao_record)
  #     faa_icao_record = [ raw_faa_icao_record['Manufacturer'] + ' ' + raw_faa_icao_record['Model'] ]
  #     bts_record = Aircraft.bts_name_dictionary.left_to_right faa_icao_record
  #     retval = case wants
  #     when :bts_aircraft_type_code
  #       bts_record['Code']
  #     when :bts_name
  #       bts_record['Description']
  #     end if bts_record
  #     @_match[raw_faa_icao_record] = retval
  #   end
  # end
  # 
  # class Aircraft::FuelUseMatcher
  #   def match(raw_fuel_use_record)
  #     @_match ||= Hash.new
  #     return @_match[raw_fuel_use_record] if @_match.has_key?(raw_fuel_use_record)
  #     
  #     aircraft_record = if raw_fuel_use_record['ICAO'] =~ /\A[0-9A-Z]+\z/
  #       Aircraft.find_by_icao_code raw_fuel_use_record['ICAO']
  #     end
  #     
  #     aircraft_record ||= if raw_fuel_use_record['Aircraft Name'].present?
  #       Aircraft.icao_name_dictionary.left_to_right [ raw_fuel_use_record['Aircraft Name'] ]
  #     end
  #     
  #     if aircraft_record
  #       @_match[raw_fuel_use_record] = aircraft_record.icao_code
  #     else
  #       raise "Didn't find a match for #{raw_fuel_use_record['Aircraft Name']} (#{raw_fuel_use_record['ICAO']}), which we found in the fuel use spreadsheet"
  #     end
  #   end
  # end
  
  # For errata
  class Aircraft::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A([a-z]+)_is_n?o?t?_?([^\?]+)/
        column_name = $1
        value = $2
        value_regexp = Regexp.new("^" + value.gsub('_', ' ') + "$", Regexp::IGNORECASE)
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
  
  def self.manufacturer_whitelist?(candidate)
    @manufacturer_whitelist ||= RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFRFalpOdlg1cnF6amlSM1dDc1lya2c&output=csv')
    @manufacturer_whitelist.any? { |record| record['Manufacturer'].to_regexp.match(candidate) }
  end
  
  data_miner do
    schema Earth.database_options do
      string 'icao_code'
      string 'manufacturer_name'
      string 'name'
      string 'type'
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
             :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdF96ZWRuSzlsSm5PSlZ0XzlwRGRuemc&output=csv',
                          :responder => Aircraft::Guru.new },
             :select => lambda { |record| manufacturer_whitelist? record['Manufacturer'] } do
        key 'icao_code',           :field_name => 'Designator'
        store 'manufacturer_name', :field_name => 'Manufacturer'
        store 'name',              :field_name => 'Model'
        # store 'type',              :field_name => 'Type/Wt Class', :chars => 0
        # store 'engine_type',       :field_name => 'Type/Wt Class', :chars => 2
        # store 'engines',           :field_name => 'Type/Wt Class', :chars => 1
        # store 'weight_class',      :field_name => 'Type/Wt Class', :split => { :pattern => %r{/}, :keep => 1 }
      end
    end
    
    # import "aircraft not included in the FAA database",
    #        :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRNaVpSUWw2Z2VhN3RUV25yYWdQX2c&output=csv' do
    #   key 'icao_code'
    #   store 'manufacturer_name'
    #   store 'name'
    # end
    
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
