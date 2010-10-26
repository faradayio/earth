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
  
  # for errata
  class Aircraft::Guru
    def is_a_dc_plane?(row)
      row['Designator'] =~ /^DC\d/i
    end
    
    def is_a_g159?(row)
      row['Designator'] =~ /^G159$/
    end
    
    def is_a_galx?(row)
      row['Designator'] =~ /^GALX$/
    end
    
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\Ais_n?o?t?_?attributed_to_([^\?]+)/
        manufacturer_name = $1
        manufacturer_regexp = Regexp.new(manufacturer_name.gsub('_', ' ?'), Regexp::IGNORECASE)
        matches = manufacturer_regexp.match(args.first['Manufacturer']) # row['Manufacturer'] =~ /mcdonnell douglas/i
        method_id.to_s.include?('not_attributed') ? matches.nil? : !matches.nil?
      else
        super
      end
    end
  end
  
  data_miner do
    schema Earth.database_options do
      string 'bp_code'
      string 'aircraft_bts_code'
      string 'icao_code'
      string 'class_code'
      string 'fuel_use_code'
      string 'icao_manufacturer_name'
      string 'icao_name'
      string 'bts_name'
      string 'fuel_use_aircraft_name'
      float  'm3'
      string 'm3_units'
      float  'm2'
      string 'm2_units'
      float  'm1'
      string 'm1_units'
      float  'endpoint_fuel'
      string 'endpoint_fuel_units'
      float  'seats'
      float  'weighting'
      index  'aircraft_bts_code'
    end
    
    import "a list of aircraft and their associated icao, bts, class, and fuel use codes",
            :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDJFblR4MDE1RGtnLVM1S2JHRGZpT3c&hl=en&single=true&gid=0&output=csv' do
      key 'bp_code'
      store 'icao_code',     :field_name => 'icao_code'
      store 'bts_code',      :field_name => 'bts_code'
      store 'class_code',    :field_name => 'class_code'
      store 'fuel_use_code', :field_name => 'fuel_use_code'
    end
    
    ('A'..'Z').each do |letter|
      import( "ICAO manufacturers and names for aircraft with an ICAO code starting with the letter #{letter} from the FAA",
              :url => "http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-#{letter}.htm",
              :errata => Errata.new(:url => 'http://spreadsheets.google.com/pub?key=tObVAGyqOkCBtGid0tJUZrw',
                                    :responder => Aircraft::Guru.new),
              :encoding => 'windows-1252',
              :row_xpath => '//table/tr[2]/td/table/tr',
              :column_xpath => 'td' ) do
        key 'icao_code',       :field_name => 'Designator'
        store 'icao_manufacturer_name', :field_name => 'Manufacturer'
        store 'icao_name',     :field_name => 'Model'
      end
    end
    
    import "some hand-picked ICAO manufacturers and names, including some for ICAO codes not used by the FAA",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRNaVpSUWw2Z2VhN3RUV25yYWdQX2c&hl=en&single=true&gid=0&output=csv' do
      key 'icao_code',       :field_name => 'icao_code'
      store 'icao_manufacturer_name', :field_name => 'manufacturer_name'
      store 'icao_name',     :field_name => 'name'
    end
    
    import "aircraft BTS names",
           :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE',
           :errata => Errata.new(:url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEZ2d3JQMzV5T1o1T3JmVlFyNUZxdEE&hl=en&single=true&gid=0&output=csv') do
      key 'bts_code',   :field_name => 'Code'
      store 'bts_name', :field_name => 'Description'
    end
    
    import "the fuel use equations associated with each fuel use code",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG9tSC1RczJOdjliWTdjT2ZpdV9RTnc&hl=en&single=true&gid=0&output=csv' do
      key   'fuel_use_code', :field_name => 'fuel_use_code'
      store 'fuel_use_aircraft_name', :field_name => 'aircraft_name'
      store 'm3', :units => :kilograms_per_cubic_nautical_mile
      store 'm2', :units => :kilograms_per_square_nautical_mile
      store 'm1', :units => :kilograms_per_nautical_mile
      store 'endpoint_fuel', :field_name => 'b', :units => :kilograms
    end
    
    process "Derive some average flight characteristics from flight segments" do
      FlightSegment.run_data_miner!
      
      aircraft = Aircraft.arel_table
      segments = FlightSegment.arel_table
      
      # non-working joins method
      # update_all "aircraft.distance_1            = (SELECT * FROM (#{FlightSegment.joins(:aircraft).weighted_average_relation(:distance,            :weighted_by => :passengers                                           ).to_sql}) AS anonymous_1)"
      # update_all "aircraft.load_factor_1         = (SELECT * FROM (#{FlightSegment.joins(:aircraft).weighted_average_relation(:load_factor,         :weighted_by => :passengers                                           ).to_sql}) AS anonymous_1)"
      # execute %{
      #   update aircraft as t1
      #   set t1.distance_1 = (SELECT * FROM (#{FlightSegment.joins(:aircraft).weighted_average_relation(:distance,            :weighted_by => :passengers                                           ).where('t1.bts_aircraft_type_code = flight_segments.bts_aircraft_type_code').to_sql}) AS anonymous_1)
      # }
      
      # FIXME TODO
      # This should calculate weighted averages from flight segments
      # For example, to calculate seats:
      # SELECT aircraft.icao_code, sum(flight_segments.seats * flight_segments.passengers) / sum(flight_segments.passengers)
      # FROM flight_segments
      # INNER JOIN aircraft_aircraft_types ON flight_segments.aircraft_type_code = aircraft_aircraft_types.aircraft_type_code
      # INNER JOIN aircraft ON aircraft_aircraft_types.icao_code = aircraft.icao_code
      # GROUP BY aircraft.icao_code
      
      conditional_relation = segments[:aircraft_bts_code].eq(aircraft[:bts_code])
      update_all "seats     = (#{segment.weighted_average_relation(:seats, :weighted_by => :passengers).where(conditional_relation).to_sql})"
      update_all "weighting = (#{segments.project(segments[:passengers].sum).where(conditional_relation).to_sql})"
      
      # conditional_relation = aircraft[:aircraft_type_code].eq(segments[:aircraft_type_code])
      
      # update_all "seats         = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      
      # update_all "distance      = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "load_factor   = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "freight_share = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "payload       = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).where(conditional_relation).to_sql})"
      
      # update_all "weighting = (#{segments.project(segments[:passengers].sum).where(aircraft[:aircraft_type_code].eq(segments[:aircraft_type_code])).to_sql})"
    end
    
    process "Synthesize AircraftManufacturer" do
       AircraftManufacturer.run_data_miner!
     end
   end
end
