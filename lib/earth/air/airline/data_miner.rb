require 'errata'

Airline.class_eval do
  class Airline::Guru
    # needed by errata
    def is_not_coral_air?(row); row['Code'].to_i != 19155; end                # 19155 Coral Air Inc.: COR
    def is_not_aviacion_y_comercio?(row); row['Code'].to_i != 19452; end      # 19452 Aviacion Y Comercio S.A.: AO
    def is_not_air_china?(row); row['Code'].to_i != 19543; end                # 19543 Air China: CA
    def is_not_south_african_airways?(row); row['Code'].to_i != 19570; end    # 19570 South African Airways: SA
    def is_not_continental_airlines?(row); row['Code'].to_i != 19704; end     # 19704 Continental Air Lines Inc.: CO
    def is_not_sallee_s_aviation?(row); row['Code'].to_i != 19740; end        # 19740 Sallee's Aviation: SAL
    def is_not_air_berlin?(row); row['Code'].to_i != 21361; end               # "21361","Air Berlin PLC and CO: AB"
  end

  data_miner do
    schema Earth.database_options do
      string   'iata_code'
      string   'name'
      string   'dot_airline_id_code'
      boolean  'international'
      float    'seats'
      float    'distance'
      string   'distance_units'
      float    'load_factor'
      float    'freight_share'
      float    'payload'
      string   'payload_units'
    end
    
    import "the T100 AIRLINE_ID lookup table, which also includes IATA codes",
           :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRLINE_ID',
           :errata => { :url => 'http://static.brighterplanet.com/science/data/transport/air/airlines/errata.csv', :responder => Airline::Guru.new } do
      key 'iata_code', :field_name => 'Description', :split => { :pattern => /:/, :keep => 1 }
      store 'dot_airline_id_code', :field_name => 'Code'
      store 'name', :field_name => 'Description', :split => { :pattern => /:/, :keep => 0 }
    end
    
    process "Determine whether airlines fly internationally by looking at flight segments" do
      FlightSegment.run_data_miner!
      update_all 'international = 1', '(SELECT COUNT(*) FROM flight_segments WHERE flight_segments.airline_iata_code = airlines.iata_code AND flight_segments.origin_country_iso_3166_code != flight_segments.destination_country_iso_3166_code AND flight_segments.origin_country_iso_3166_code IS NOT NULL AND flight_segments.destination_country_iso_3166_code IS NOT NULL) > 0'
    end
    
    process "Derive some average flight characteristics from flight segments" do
      FlightSegment.run_data_miner!
      airlines = Airline.arel_table
      segments = FlightSegment.arel_table
      
      conditional_relation = airlines[:iata_code].eq(segments[:airline_iata_code])

      update_all "seats                    = (#{FlightSegment.weighted_average_relation(:seats,               :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      update_all "distance                 = (#{FlightSegment.weighted_average_relation(:distance,            :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      update_all "load_factor              = (#{FlightSegment.weighted_average_relation(:load_factor,         :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      update_all "freight_share            = (#{FlightSegment.weighted_average_relation(:freight_share,       :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      update_all "payload                  = (#{FlightSegment.weighted_average_relation(:payload,             :weighted_by => :passengers, :disaggregate_by => :departures_performed).where(conditional_relation).to_sql})"
    end
  end
end

