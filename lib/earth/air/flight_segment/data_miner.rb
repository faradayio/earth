FlightSegment.class_eval do
  # For import errata
  class FlightSegment::Guru
    def in_may_2009?(row)
      row ['MONTH'] == 5 and row['YEAR'] == 2009
    end
    
    def in_july_2009?(row)
      row ['MONTH'] == 7 and row['YEAR'] == 2009
    end
  end
  
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
    months = Hash.new
    (2009..2011).each do |year|
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
             # FIXME TODO 6/6/2011 the errata doesn't work - still doesn't fill in missing airline in May and July 2009
             :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGxpYU1qWFR3d0syTVMyQVVOaDd0V3c&output=csv', :responder => FlightSegment::Guru.new },
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
    
    process "Ensure Airline and BtsAircraft are populated" do
      Airline.run_data_miner!
      BtsAircraft.run_data_miner!
    end
    
    process "Look up airline name based on BTS code" do
      connection.select_values("SELECT DISTINCT airline_bts_code FROM flight_segments WHERE airline_bts_code IS NOT NULL").each do |bts_code|
        if airline = Airline.find_by_bts_code(bts_code)
          update_all %{ airline_name = "#{airline.name}" }, %{ airline_bts_code = "#{bts_code}" }
        end
      end
    end
    
    process "Look up aircraft description based on BTS code" do
      connection.select_values("SELECT DISTINCT aircraft_bts_code FROM flight_segments WHERE aircraft_bts_code IS NOT NULL").each do |bts_code|
        if aircraft = BtsAircraft.find_by_bts_code(bts_code)
          update_all %{ aircraft_description = "#{aircraft.description.downcase}" }, %{ aircraft_bts_code = "#{bts_code}" }
        end
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
    
    process "Data mine Aircraft to cache fuzzy matches" do
      Aircraft.run_data_miner!
    end
    
    # verify origin_airport_iata_code is in airports
    # verify destination_airport_iata_code is in airports
    # verify origin_country_iso_3166_code is in countries
    # verify destination_country_iso_3166_code is in countries
    # verify airline_name is never missing
    # verify aircraft_description is never missing
    # verify year is never missing
  end
end
