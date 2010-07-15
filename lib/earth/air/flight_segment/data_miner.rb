FlightSegment.class_eval do
  data_miner do
    process "Don't re-import too often" do
      raise DataMiner::Skip unless DataMiner::Run.allowed? FlightSegment
    end
    
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string   'row_hash'
      string   'propulsion'
      integer  'bts_aircraft_group_code'
      string   'configuration'
      integer  'bts_aircraft_configuration_code'
      string   'distance_group'
      integer  'bts_distance_group_code'
      string   'service_class'
      string   'bts_service_class_code'
      string   'domesticity'
      string   'bts_data_source_code'
      integer  'departures_performed'
      integer  'payload'
      integer  'total_seats'
      integer  'passengers'
      integer  'freight'
      integer  'mail'
      integer  'ramp_to_ramp'
      integer  'air_time'
      float    'load_factor'
      float    'freight_share'
      integer  'distance'
      integer  'departures_scheduled'
      string   'airline_iata_code'
      string   'dot_airline_id_code'
      string   'unique_carrier_name'
      string   'unique_carrier_entity'
      string   'region'
      string   'current_airline_iata_code'
      string   'carrier_name'
      integer  'carrier_group'
      integer  'carrier_group_new'
      string   'origin_airport_iata_code'
      string   'origin_city_name'
      integer  'origin_city_num'
      string   'origin_state_abr'
      string   'origin_state_fips'
      string   'origin_state_nm'
      string   'origin_country_iso_3166_code'
      string   'origin_country_name'
      integer  'origin_wac'
      string   'dest_airport_iata_code'
      string   'dest_city_name'
      integer  'dest_city_num'
      string   'dest_state_abr'
      string   'dest_state_fips'
      string   'dest_state_nm'
      string   'dest_country_iso_3166_code'
      string   'dest_country_name'
      integer  'dest_wac'
      integer  'bts_aircraft_type_code'
      integer  'year'
      integer  'quarter'
      integer  'month'
      float    'seats'
      string   'payload_units'
      string   'freight_units'
      string   'mail_units'
      string   'distance_units'
      index    'airline_iata_code'
      index    'bts_aircraft_type_code'
      index    'origin_airport_iata_code'
      index    'dest_airport_iata_code'
      index    'domesticity'
      # add_index "flight_segments", ["flight_airline_id", "origin_airport_id", "destination_airport_id", "flight_configuration_id", "flight_aircraft_id", "flight_propulsion_id", "flight_service_id", "origin_country_id", "destination_country_id"], :name => "super_4_index"
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
    propulsion_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_GROUP'
    configuration_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_CONFIG'
    distance_group_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_DISTANCE_GROUP_500'
    service_class_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_SERVICE_CLASS'
    domesticity_dictionary = DataMiner::Dictionary.new :input => 'Code', :output => 'Description', :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_DATA_SOURCE'
    months.each do |month, form_data|
      import "T100 flight segment data from #{month.strftime('%B %Y')}",
             :url => URL,
             :form_data => form_data,
             :compression => :zip,
             :glob => '/*.csv' do
        
        key 'row_hash'
        
        store 'propulsion', :field_name => 'AIRCRAFT_GROUP', :dictionary => propulsion_dictionary
        store 'bts_aircraft_group_code', :field_name => 'AIRCRAFT_GROUP'
        
        store 'configuration', :field_name => 'AIRCRAFT_CONFIG', :dictionary => configuration_dictionary
        store 'bts_aircraft_configuration_code', :field_name => 'AIRCRAFT_CONFIG'
        
        store 'distance_group', :field_name => 'DISTANCE_GROUP', :dictionary => distance_group_dictionary
        store 'bts_distance_group_code', :field_name => 'DISTANCE_GROUP'
        
        store 'service_class', :field_name => 'CLASS', :dictionary => service_class_dictionary
        store 'bts_service_class_code', :field_name => 'CLASS'
        
        store 'domesticity', :field_name => 'DATA_SOURCE', :dictionary => domesticity_dictionary
        store 'bts_data_source_code', :field_name => 'DATA_SOURCE'
        
        store 'departures_scheduled', :field_name => 'DEPARTURES_SCHEDULED'
        store 'departures_performed', :field_name => 'DEPARTURES_PERFORMED'
        store 'payload', :field_name => 'PAYLOAD', :from_units => :pounds, :to_units => :kilograms
        store 'total_seats', :field_name => 'SEATS'
        store 'passengers', :field_name => 'PASSENGERS'
        store 'freight', :field_name => 'FREIGHT', :from_units => :pounds, :to_units => :kilograms
        store 'mail', :field_name => 'MAIL', :from_units => :pounds, :to_units => :kilograms
        store 'distance', :field_name => 'DISTANCE', :from_units => :miles, :to_units => :kilometres
        store 'ramp_to_ramp', :field_name => 'RAMP_TO_RAMP'
        store 'air_time', :field_name => 'AIR_TIME'
        store 'airline_iata_code', :field_name => 'UNIQUE_CARRIER' # adjusted for uniqueness
        store 'dot_airline_id_code', :field_name => 'AIRLINE_ID'
        store 'unique_carrier_name', :field_name => 'UNIQUE_CARRIER_NAME'
        store 'unique_carrier_entity', :field_name => 'UNIQUE_CARRIER_ENTITY'
        store 'region', :field_name => 'REGION'
        store 'current_airline_iata_code', :field_name => 'CARRIER'
        store 'carrier_name', :field_name => 'CARRIER_NAME'
        store 'carrier_group', :field_name => 'CARRIER_GROUP'
        store 'carrier_group_new', :field_name => 'CARRIER_GROUP_NEW'
        store 'origin_airport_iata_code', :field_name => 'ORIGIN'
        store 'origin_city_name', :field_name => 'ORIGIN_CITY_NAME'
        store 'origin_city_num', :field_name => 'ORIGIN_CITY_NUM'
        store 'origin_state_abr', :field_name => 'ORIGIN_STATE_ABR'
        store 'origin_state_fips', :field_name => 'ORIGIN_STATE_FIPS'
        store 'origin_state_nm', :field_name => 'ORIGIN_STATE_NM'
        store 'origin_country_iso_3166_code', :field_name => 'ORIGIN_COUNTRY'
        store 'origin_country_name', :field_name => 'ORIGIN_COUNTRY_NAME'
        store 'origin_wac', :field_name => 'ORIGIN_WAC'
        store 'dest_airport_iata_code', :field_name => 'DEST'
        store 'dest_city_name', :field_name => 'DEST_CITY_NAME'
        store 'dest_city_num', :field_name => 'DEST_CITY_NUM'
        store 'dest_state_abr', :field_name => 'DEST_STATE_ABR'
        store 'dest_state_fips', :field_name => 'DEST_STATE_FIPS'
        store 'dest_state_nm', :field_name => 'DEST_STATE_NM'
        store 'dest_country_iso_3166_code', :field_name => 'DEST_COUNTRY'
        store 'dest_country_name', :field_name => 'DEST_COUNTRY_NAME'
        store 'dest_wac', :field_name => 'DEST_WAC'
        store 'bts_aircraft_type_code', :field_name => 'AIRCRAFT_TYPE' # lol no dictionary please
        store 'year', :field_name => 'YEAR'
        store 'quarter', :field_name => 'QUARTER'
        store 'month', :field_name => 'MONTH'
      end
    end
    
    process "Derive freight share as a fraction of payload" do
      update_all 'freight_share = (freight + mail) / payload', 'payload > 0'
    end

    process "Derive load factor, which is passengers divided by the total seats available" do
      update_all 'load_factor = passengers / total_seats', 'passengers <= total_seats'
    end
    
    process "Derive average seats per departure" do
      update_all 'seats = total_seats / departures_performed', 'departures_performed > 0'
    end
  end
end

