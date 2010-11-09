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
      string   'row_hash'
      integer  'departures_performed'
      integer  'passengers'
      integer  'total_seats'
      float    'payload'        # this needs to be a float because the import includes a units conversion
      string   'payload_units'
      float    'freight'        # this needs to be a float because the import includes a units conversion
      string   'freight_units'
      float    'mail'           # this needs to be a float because the import includes a units conversion
      string   'mail_units'
      float    'load_factor'
      float    'freight_share'
      float    'seats'
      float    'distance'
      string   'distance_units'
      string   'aircraft_bts_code'
      string   'airline_iata_code'
      string   'origin_airport_iata_code'
      string   'origin_country_iso_3166_code'
      string   'destination_airport_iata_code'
      string   'destination_country_iso_3166_code'
      integer  'year'
      integer  'quarter'
      integer  'month'
      # integer  'bts_aircraft_group_code'
      # string   'configuration_id'
      # integer  'bts_aircraft_configuration_code'
      # string   'distance_group'
      # integer  'bts_distance_group_code'
      # string   'bts_data_source_code'
      # integer  'ramp_to_ramp'
      # integer  'air_time'
      # integer  'departures_scheduled'
      # string   'dot_airline_id_code'
      # string   'unique_carrier_name'
      # string   'unique_carrier_entity'
      # string   'region'
      # string   'current_airline_iata_code'
      # string   'carrier_name'
      # integer  'carrier_group'
      # integer  'carrier_group_new'
      # string   'origin_city_name'
      # integer  'origin_city_num'
      # string   'origin_state_abr'
      # string   'origin_state_fips'
      # string   'origin_state_nm'
      # string   'origin_country_name'
      # integer  'origin_wac'
      # string   'dest_city_name'
      # integer  'dest_city_num'
      # string   'dest_state_abr'
      # string   'dest_state_fips'
      # string   'dest_state_nm'
      # string   'dest_country_name'
      # integer  'dest_wac'
      index    'airline_iata_code'
      index    'aircraft_bts_code'
      index    'origin_airport_iata_code'
      index    'destination_airport_iata_code'
    end
    
    months = Hash.new
    (2008..2009).each do |year|
    # (2008..2008).each do |year| # DEBUG MODE!
      (1..12).each do |month|
      # (1..1).each do |month| # DEBUG MODE!
        time = Time.gm year, month
        form_data = FORM_DATA.dup
        form_data.gsub! '__YEAR__', time.year.to_s
        form_data.gsub! '__MONTH_NUMBER__', time.month.to_s
        form_data.gsub! '__MONTH_NAME__', time.strftime('%B')
        months[time] = form_data
      end
    end
    # creating dictionaries by hand so that a new one doesn't get created for every month
    # distance_group_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_DISTANCE_GROUP_500'
    months.each do |month, form_data|
      import "T100 flight segment data from #{month.strftime('%B %Y')}",
             :url => URL,
             :form_data => form_data,
             :compression => :zip,
             :glob => '/*.csv' do
        
        key 'row_hash'
        
        # store 'bts_aircraft_group_code', :field_name => 'AIRCRAFT_GROUP'
        
        # store 'configuration_id', :field_name => 'AIRCRAFT_CONFIG', :dictionary => configuration_dictionary
        #         store 'bts_aircraft_configuration_code', :field_name => 'AIRCRAFT_CONFIG'
        
        # store 'distance_group', :field_name => 'DISTANCE_GROUP', :dictionary => distance_group_dictionary
        #         store 'bts_distance_group_code', :field_name => 'DISTANCE_GROUP'
        
        #       store 'bts_data_source_code', :field_name => 'DATA_SOURCE'
        
        # store 'departures_scheduled', :field_name => 'DEPARTURES_SCHEDULED'
        store 'departures_performed',              :field_name => 'DEPARTURES_PERFORMED'
        store 'passengers',                        :field_name => 'PASSENGERS'
        store 'total_seats',                       :field_name => 'SEATS'
        store 'payload',                           :field_name => 'PAYLOAD',       :from_units => :pounds, :to_units => :kilograms
        store 'freight',                           :field_name => 'FREIGHT',       :from_units => :pounds, :to_units => :kilograms
        store 'mail',                              :field_name => 'MAIL',          :from_units => :pounds, :to_units => :kilograms
        store 'distance',                          :field_name => 'DISTANCE',      :from_units => :miles,  :to_units => :kilometres
        store 'aircraft_bts_code',                 :field_name => 'AIRCRAFT_TYPE'
        store 'airline_iata_code',                 :field_name => 'UNIQUE_CARRIER'
        store 'origin_airport_iata_code',          :field_name => 'ORIGIN'
        store 'origin_country_iso_3166_code',      :field_name => 'ORIGIN_COUNTRY'
        store 'destination_airport_iata_code',     :field_name => 'DEST'
        store 'destination_country_iso_3166_code', :field_name => 'DEST_COUNTRY'
        store 'year',                              :field_name => 'YEAR'
        store 'quarter',                           :field_name => 'QUARTER'
        store 'month',                             :field_name => 'MONTH'
        # store 'ramp_to_ramp', :field_name => 'RAMP_TO_RAMP'
        # store 'air_time', :field_name => 'AIR_TIME'
        # store 'dot_airline_id_code', :field_name => 'AIRLINE_ID'
        # store 'unique_carrier_name', :field_name => 'UNIQUE_CARRIER_NAME'
        # store 'unique_carrier_entity', :field_name => 'UNIQUE_CARRIER_ENTITY'
        # store 'region', :field_name => 'REGION'
        # store 'current_airline_iata_code', :field_name => 'CARRIER'
        # store 'carrier_name', :field_name => 'CARRIER_NAME'
        # store 'carrier_group', :field_name => 'CARRIER_GROUP'
        # store 'carrier_group_new', :field_name => 'CARRIER_GROUP_NEW'
        # store 'origin_city_name', :field_name => 'ORIGIN_CITY_NAME'
        # store 'origin_city_num', :field_name => 'ORIGIN_CITY_NUM'
        # store 'origin_state_abr', :field_name => 'ORIGIN_STATE_ABR'
        # store 'origin_state_fips', :field_name => 'ORIGIN_STATE_FIPS'
        # store 'origin_state_nm', :field_name => 'ORIGIN_STATE_NM'
        # store 'origin_country_name', :field_name => 'ORIGIN_COUNTRY_NAME'
        # store 'origin_wac', :field_name => 'ORIGIN_WAC'
        # store 'dest_city_name', :field_name => 'DEST_CITY_NAME'
        # store 'dest_city_num', :field_name => 'DEST_CITY_NUM'
        # store 'dest_state_abr', :field_name => 'DEST_STATE_ABR'
        # store 'dest_state_fips', :field_name => 'DEST_STATE_FIPS'
        # store 'dest_state_nm', :field_name => 'DEST_STATE_NM'
        # store 'dest_country_name', :field_name => 'DEST_COUNTRY_NAME'
        # store 'dest_wac', :field_name => 'DEST_WAC'
      end
    end
    
    process "Derive freight share as a fraction of payload" do
      update_all 'freight_share = (freight + mail) / payload', 'payload > 0'
    end
    
    process "Derive load factor, which is passengers divided by the total seats available" do
      update_all 'load_factor = passengers / total_seats', 'total_seats > 0'
    end
    
    process "Assume a load factor of 1 where passengers > total seats available" do
      update_all 'load_factor = 1', 'passengers > total_seats AND total_seats > 0'
    end
    
    process "Derive average seats per departure" do
      update_all 'seats = total_seats / departures_performed', 'departures_performed > 0'
    end
  end
end
