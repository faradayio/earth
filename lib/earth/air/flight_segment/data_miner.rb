# need this to run flight_segment.cache_aircraft!
require 'loose_tight_dictionary/cached_result'

FlightSegment.class_eval do
  URL = 'http://www.transtats.bts.gov/DownLoad_Table.asp?Table_ID=293&Has_Group=3&Is_Zipped=0'
  FORM_DATA = %{
    UserTableName=T_100_Segment__All_Carriers&
    DBShortName=Air_Carriers&
    RawDataTable=T_T100_SEGMENT_ALL_CARRIER&
    sqlstr=+SELECT+DEPARTURES_SCHEDULED%2CDEPARTURES_PERFORMED%2CPAYLOAD%2CSEATS%2CPASSENGERS%2CFREIGHT%2CMAIL%2CDISTANCE%2CRAMP_TO_RAMP%2CAIR_TIME%2CUNIQUE_CARRIER%2CAIRLINE_ID%2CUNIQUE_CARRIER_NAME%2CUNIQUE_CARRIER_ENTITY%2CREGION%2CCARRIER%2CCARRIER_NAME%2CCARRIER_GROUP%2CCARRIER_GROUP_NEW%2CORIGIN%2CORIGIN_CITY_NAME%2CORIGIN_CITY_NUM%2CORIGIN_STATE_ABR%2CORIGIN_STATE_FIPS%2CORIGIN_STATE_NM%2CORIGIN_COUNTRY%2CORIGIN_COUNTRY_NAME%2CORIGIN_WAC%2CDEST%2CDEST_CITY_NAME%2CDEST_CITY_NUM%2CDEST_STATE_ABR%2CDEST_STATE_FIPS%2CDEST_STATE_NM%2CDEST_COUNTRY%2CDEST_COUNTRY_NAME%2CDEST_WAC%2CAIRCRAFT_GROUP%2CAIRCRAFT_TYPE%2CAIRCRAFT_CONFIG%2CYEAR%2CQUARTER%2CMONTH%2CDISTANCE_GROUP%2CCLASS%2CDATA_SOURCE+FROM++T_T100_SEGMENT_ALL_CARRIER+WHERE+Month+%3D__MONTH_NUMBER__+AND+YEAR%3D__YEAR__&
    varlist=DEPARTURES_SCHEDULED%2CDEPARTURES_PERFORMED%2CPAYLOAD%2CSEATS%2CPASSENGERS%2CFREIGHT%2CMAIL%2CDISTANCE%2CRAMP_TO_RAMP%2CAIR_TIME%2CUNIQUE_CARRIER%2CAIRLINE_ID%2CUNIQUE_CARRIER_NAME%2CUNIQUE_CARRIER_ENTITY%2CREGION%2CCARRIER%2CCARRIER_NAME%2CCARRIER_GROUP%2CCARRIER_GROUP_NEW%2CORIGIN%2CORIGIN_CITY_NAME%2CORIGIN_CITY_NUM%2CORIGIN_STATE_ABR%2CORIGIN_STATE_FIPS%2CORIGIN_STATE_NM%2CORIGIN_COUNTRY%2CORIGIN_COUNTRY_NAME%2CORIGIN_WAC%2CDEST%2CDEST_CITY_NAME%2CDEST_CITY_NUM%2CDEST_STATE_ABR%2CDEST_STATE_FIPS%2CDEST_STATE_NM%2CDEST_COUNTRY%2CDEST_COUNTRY_NAME%2CDEST_WAC%2CAIRCRAFT_GROUP%2CAIRCRAFT_TYPE%2CAIRCRAFT_CONFIG%2CYEAR%2CQUARTER%2CMONTH%2CDISTANCE_GROUP%2CCLASS%2CDATA_SOURCE&
    grouplist=&
    suml=&
    sumRegion=&
    filter1=title%3D&
    filter2=title%3D&
    geo=All%A0&
    time=__MONTH_NAME__&
    timename=Month&
    GEOGRAPHY=All&
    XYEAR=__YEAR__&
    FREQUENCY=__MONTH_NUMBER__&
    AllVars=All&
    VarName=DEPARTURES_SCHEDULED&
    VarDesc=DepScheduled&
    VarType=Num&
    VarName=DEPARTURES_PERFORMED&
    VarDesc=DepPerformed&
    VarType=Num&
    VarName=PAYLOAD&
    VarDesc=Payload&
    VarType=Num&
    VarName=SEATS&
    VarDesc=Seats&
    VarType=Num&
    VarName=PASSENGERS&
    VarDesc=Passengers&
    VarType=Num&
    VarName=FREIGHT&
    VarDesc=Freight&
    VarType=Num&
    VarName=MAIL&
    VarDesc=Mail&
    VarType=Num&
    VarName=DISTANCE&
    VarDesc=Distance&
    VarType=Num&
    VarName=RAMP_TO_RAMP&
    VarDesc=RampToRamp&
    VarType=Num&
    VarName=AIR_TIME&
    VarDesc=AirTime&
    VarType=Num&
    VarName=UNIQUE_CARRIER&
    VarDesc=UniqueCarrier&
    VarType=Char&
    VarName=AIRLINE_ID&
    VarDesc=AirlineID&
    VarType=Num&
    VarName=UNIQUE_CARRIER_NAME&
    VarDesc=UniqueCarrierName&
    VarType=Char&
    VarName=UNIQUE_CARRIER_ENTITY&
    VarDesc=UniqCarrierEntity&
    VarType=Char&
    VarName=REGION&
    VarDesc=CarrierRegion&
    VarType=Char&
    VarName=CARRIER&
    VarDesc=Carrier&
    VarType=Char&
    VarName=CARRIER_NAME&
    VarDesc=CarrierName&
    VarType=Char&
    VarName=CARRIER_GROUP&
    VarDesc=CarrierGroup&
    VarType=Num&
    VarName=CARRIER_GROUP_NEW&
    VarDesc=CarrierGroupNew&
    VarType=Num&
    VarName=ORIGIN&
    VarDesc=Origin&
    VarType=Char&
    VarName=ORIGIN_CITY_NAME&
    VarDesc=OriginCityName&
    VarType=Char&
    VarName=ORIGIN_CITY_NUM&
    VarDesc=OriginCityNum&
    VarType=Num&
    VarName=ORIGIN_STATE_ABR&
    VarDesc=OriginState&
    VarType=Char&
    VarName=ORIGIN_STATE_FIPS&
    VarDesc=OriginStateFips&
    VarType=Char&
    VarName=ORIGIN_STATE_NM&
    VarDesc=OriginStateName&
    VarType=Char&
    VarName=ORIGIN_COUNTRY&
    VarDesc=OriginCountry&
    VarType=Char&
    VarName=ORIGIN_COUNTRY_NAME&
    VarDesc=OriginCountryName&
    VarType=Char&
    VarName=ORIGIN_WAC&
    VarDesc=OriginWac&
    VarType=Num&
    VarName=DEST&
    VarDesc=Dest&
    VarType=Char&
    VarName=DEST_CITY_NAME&
    VarDesc=DestCityName&
    VarType=Char&
    VarName=DEST_CITY_NUM&
    VarDesc=DestCityNum&
    VarType=Num&
    VarName=DEST_STATE_ABR&
    VarDesc=DestState&
    VarType=Char&
    VarName=DEST_STATE_FIPS&
    VarDesc=DestStateFips&
    VarType=Char&
    VarName=DEST_STATE_NM&
    VarDesc=DestStateName&
    VarType=Char&
    VarName=DEST_COUNTRY&
    VarDesc=DestCountry&
    VarType=Char&
    VarName=DEST_COUNTRY_NAME&
    VarDesc=DestCountryName&
    VarType=Char&
    VarName=DEST_WAC&
    VarDesc=DestWac&
    VarType=Num&
    VarName=AIRCRAFT_GROUP&
    VarDesc=AircraftGroup&
    VarType=Num&
    VarName=AIRCRAFT_TYPE&
    VarDesc=AircraftType&
    VarType=Char&
    VarName=AIRCRAFT_CONFIG&
    VarDesc=AircraftConfig&
    VarType=Num&
    VarName=YEAR&
    VarDesc=Year&
    VarType=Num&
    VarName=QUARTER&
    VarDesc=Quarter&
    VarType=Num&
    VarName=MONTH&
    VarDesc=Month&
    VarType=Num&
    VarName=DISTANCE_GROUP&
    VarDesc=DistanceGroup&
    VarType=Num&
    VarName=CLASS&
    VarDesc=Class&
    VarType=Char&
    VarName=DATA_SOURCE&
    VarDesc=DataSource&
    VarType=Char
  }.gsub /[\s]+/,''
  
  data_miner do
    schema Earth.database_options do
      string  'row_hash'                          # auto-generated primary key
      string  'origin_airport_iata_code'          # iata code
      string  'origin_airport_city'               # city
      string  'origin_country_iso_3166_code'      # iso code
      string  'destination_airport_iata_code'     # iata code
      string  'destination_airport_city'          # city
      string  'destination_country_iso_3166_code' # iso code
      string  'airline_bts_code'                  # bts code
      string  'airline_icao_code'                 # icao code
      string  'airline_name'                      # text description derived from bts or icao code
      string  'aircraft_bts_code'                 # bts code
      string  'aircraft_description'              # text description derived from BTS T100 or ICAO TFS
      integer 'flights'                           # number of flights over month or year
      integer 'passengers'                        # total passengers on all flights
      integer 'seats'                             # total seats on all flights
      integer 'seats_per_flight'                  # average seats per flight
      float   'load_factor'                       # passengers / seats
      float   'freight_share'                     # (freight + mail) / (freight + mail + (passengers * average passenger weight))
      float   'distance'                          # flight distance
      string  'distance_units'                    # 'kilometres'
      float   'payload_capacity'                  # aircraft maximum payload capacity rating; float b/c unit conversion
      string  'payload_capacity_units'            # 'kilograms'
      float   'freight'                           # total freight on all flights performed; float b/c unit conversion
      string  'freight_units'                     # 'kilograms'
      float   'mail'                              # total mail on all flights performed; float b/c unit conversion
      string  'mail_units'                        # 'kilograms'
      integer 'month'                             # month of flight
      integer 'year'                              # year of flight
      date    'approximate_date'                  # assumed 14th day of month
      string  'source'                            # 'BTS T100' or 'ICAO TFS'
      index   'origin_airport_iata_code'          # index for faster lookup by origin airport
      index   'origin_airport_city'               # index for faster lookup by origin city
      index   'destination_airport_iata_code'     # index for faster lookup by destination airport
      index   'destination_airport_city'          # index for faster lookup by destination city
      index   'airline_bts_code'                  # index for faster lookup by airline bts code
      index   'airline_icao_code'                 # index for faster lookup by airline icao code
      index   'airline_name'                      # index for faster lookup by airline name
      index   'aircraft_bts_code'                 # index for faster lookup by aircraft bts code
      index   'aircraft_description'              # index for faster lookup by aircraft
      index   'year'                              # index for faster lookup by year
    end
    
    months = Hash.new
    (2009..2010).each do |year|
      (1..12).each do |month|
        time = Time.gm year, month
        form_data = FORM_DATA.dup
        form_data.gsub! '__YEAR__', time.year.to_s
        form_data.gsub! '__MONTH_NUMBER__', time.month.to_s
        form_data.gsub! '__MONTH_NAME__', time.strftime('%B')
        months[time] = form_data
      end
    end
    
    months.each do |month, form_data|
      import "T100 flight segment data for #{month.strftime('%B %Y')}",
             :url => URL,
             :form_data => form_data,
             :compression => :zip,
             :glob => '/*.csv',
             :select => lambda { |record| record['DEPARTURES_PERFORMED'].to_i > 0 } do
        key 'row_hash'
        store 'origin_airport_iata_code',          :field_name => 'ORIGIN'
        store 'origin_country_iso_3166_code',      :field_name => 'ORIGIN_COUNTRY'
        store 'destination_airport_iata_code',     :field_name => 'DEST'
        store 'destination_country_iso_3166_code', :field_name => 'DEST_COUNTRY'
        store 'airline_bts_code',                  :field_name => 'UNIQUE_CARRIER', :nullify => true
        store 'aircraft_bts_code',                 :field_name => 'AIRCRAFT_TYPE'
        store 'flights',                           :field_name => 'DEPARTURES_PERFORMED'
        store 'passengers',                        :field_name => 'PASSENGERS'
        store 'seats',                             :field_name => 'SEATS'
        store 'payload_capacity',                  :field_name => 'PAYLOAD',  :units => 'pounds'
        store 'freight',                           :field_name => 'FREIGHT',  :units => 'pounds'
        store 'mail',                              :field_name => 'MAIL',     :units => 'pounds'
        store 'distance',                          :field_name => 'DISTANCE', :units => 'miles'
        store 'month',                             :field_name => 'MONTH'
        store 'year',                              :field_name => 'YEAR'
        store 'source',                            :static => 'BTS T100'
      end
    end
    
    # verify origin_airport_iata_code is in airports
    # verify destination_airport_iata_code is in airports
    # verify origin_country_iso_3166_code is in countries
    # verify destination_country_iso_3166_code is in countries
    # verify airline_bts_code appears in airlines
    # verify aircraft_description is never missing
    # verify year is never missing
    
    process "Look up airline name based on BTS code" do
      Airline.run_data_miner!
      connection.select_values("SELECT DISTINCT airline_bts_code FROM flight_segments WHERE airline_bts_code IS NOT NULL").each do |bts_code|
        name = Airline.find_by_bts_code(bts_code).name
        update_all %{ airline_name = "#{name}" }, %{ airline_bts_code = "#{bts_code}" }
      end
    end
    
    process "Look up aircraft description based on BTS code" do
      BtsAircraft.run_data_miner!
      connection.select_values("SELECT DISTINCT aircraft_bts_code FROM flight_segments WHERE aircraft_bts_code IS NOT NULL").each do |bts_code|
        description = BtsAircraft.find_by_bts_code(bts_code).description.downcase
        update_all %{ aircraft_description = "#{description}" }, %{ aircraft_bts_code = "#{bts_code}" }
      end
    end
    
    %w{ payload_capacity freight mail }.each do |field|
      process "Convert #{field} from pounds to kilograms" do
        conversion_factor = 1.pounds.to(:kilograms)
        connection.execute %{
          UPDATE flight_segments
          SET #{field} = #{field} * #{conversion_factor},
              #{field + '_units'} = 'kilograms'
          WHERE #{field + '_units'} = 'pounds'
        }
      end
    end
    
    process "Convert distance from miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      connection.execute %{
        UPDATE flight_segments
        SET distance = distance * #{conversion_factor},
            distance_units = 'kilometres'
        WHERE distance_units = 'miles'
      }
    end
    
    process "Derive load factor, which is passengers divided by available seats" do
      update_all 'load_factor = passengers / seats', 'seats > 0'
    end
    
    process "Assume a load factor of 1 where passengers > available seats" do
      update_all 'load_factor = 1', 'passengers > seats AND seats > 0'
    end
    
    process "Derive freight share as a fraction of the total weight carried" do
      update_all 'freight_share = (freight + mail) / (freight + mail + (passengers * 90.718474))', '(freight + mail + passengers) > 0'
    end
    
    process "Derive average seats per flight" do
      update_all 'seats_per_flight = seats / flights', 'flights > 0'
    end
    
    process "Add a useful date field" do
      update_all 'approximate_date = DATE(CONCAT_WS("-", year, month, "14"))', 'month IS NOT NULL'
    end
    
    process "Cache fuzzy matches between FlightSegment aircraft_description and Aircraft description" do
      Aircraft.run_data_miner!
      LooseTightDictionary::CachedResult.setup
      FlightSegment.find_by_sql("SELECT DISTINCT aircraft_description FROM flight_segments WHERE aircraft_description IS NOT NULL").each do |flight_segment|
        original_description = flight_segment.aircraft_description
        
        # If the flight segment's aircraft_description contains '/' then it describes multiple aircraft.
        # We need to synthesize descriptions for those aircraft, find all Aircraft that fuzzily match the
        # synthesized descriptions, and associate those Aircraft with the original aircraft_description.
        # e.g. boeing 747-100/200
        if original_description.include?("/")
          # Pull out the complete first aircraft description
          # e.g. 'boeing 747-100'
          first_description = original_description.split('/')[0]
          
          # Pull out the root of the description - the text up to and including the last ' ' or '-'
          # e.g. 'boeing 747-'
          root_length = first_description.rindex(/[ \-]/i)
          root = first_description.slice(0..root_length)
          
          # Pull out the suffixes - the text separated by forward slashes
          # e.g. ['100', '200']
          suffixes = original_description.split(root)[1].split('/')
          
          # Create an array of synthesized descriptions by appending each suffix to the root
          # e.g. ['boeing 747-100', 'boeing 747-200']
          suffixes.map{ |suffix| root + suffix }.each do |synthesized_description|
            # Look up the Aircraft that match each synthesized description and associate
            # them with the original flight segment aircraft_description
            Aircraft.loose_tight_dictionary.find_all(synthesized_description).each do |aircraft|
              attrs = {}
              attrs[:a_class] = "Aircraft"
              attrs[:a] = aircraft.description
              attrs[:b_class] = "FlightSegment"
              attrs[:b] = original_description
              unless ::LooseTightDictionary::CachedResult.exists? attrs
                ::LooseTightDictionary::CachedResult.create! attrs
              end
            end
          end
        # If the flight segment's aircraft_description doesn't contain '/' we can use
        # a method provided by loose_tight_dictionary to associate it with Aircraft
        else
          flight_segment.cache_aircraft!
        end
      end
    end
  end
end
