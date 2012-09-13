require 'earth/model'
require 'falls_back_on'
require 'fuzzy_match/cached_result'

require 'earth/air/aircraft'
require 'earth/air/airline'

class FlightSegment < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE flight_segments
  (
     row_hash                          CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     origin_airport_iata_code          CHARACTER VARYING(255),
     origin_airport_city               CHARACTER VARYING(255),
     origin_country_iso_3166_code      CHARACTER VARYING(255),
     destination_airport_iata_code     CHARACTER VARYING(255),
     destination_airport_city          CHARACTER VARYING(255),
     destination_country_iso_3166_code CHARACTER VARYING(255),
     airline_bts_code                  CHARACTER VARYING(255),
     airline_icao_code                 CHARACTER VARYING(255),
     airline_name                      CHARACTER VARYING(255), /* text description derived from bts or icao code */
     aircraft_bts_code                 CHARACTER VARYING(255),
     aircraft_description              CHARACTER VARYING(255), /* text description derived from BTS T100 or ICAO TFS */
     flights                           INTEGER,                /* number of flights over month or year */
     passengers                        INTEGER,                /* total passengers on all flights */
     seats                             INTEGER,                /* total seats on all flights */
     seats_per_flight                  FLOAT,                  /* average seats per flight */
     load_factor                       FLOAT,                  /* passengers / seats */
     freight_share                     FLOAT,                  /* (freight + mail) / (freight + mail + (passengers * average passenger weight)) */
     distance                          FLOAT,
     distance_units                    CHARACTER VARYING(255),
     payload_capacity                  FLOAT,                  /* aircraft maximum payload capacity rating */
     payload_capacity_units            CHARACTER VARYING(255),
     freight                           FLOAT,                  /* total freight on all flights performed */
     freight_units                     CHARACTER VARYING(255),
     mail                              FLOAT,                  /* total mail on all flights performed */
     mail_units                        CHARACTER VARYING(255),
     month                             INTEGER,
     year                              INTEGER,
     source                            CHARACTER VARYING(255)  /* 'BTS T100' or 'ICAO TFS' */
  );
CREATE INDEX index_flight_segments_on_origin_airport_iata_code ON flight_segments (origin_airport_iata_code);
CREATE INDEX index_flight_segments_on_origin_airport_city ON flight_segments (origin_airport_city);
CREATE INDEX index_flight_segments_on_destination_airport_iata_code ON flight_segments (destination_airport_iata_code);
CREATE INDEX index_flight_segments_on_destination_airport_city ON flight_segments (destination_airport_city);
CREATE INDEX index_flight_segments_on_airline_bts_code ON flight_segments (airline_bts_code);
CREATE INDEX index_flight_segments_on_airline_icao_code ON flight_segments (airline_icao_code);
CREATE INDEX index_flight_segments_on_airline_name ON flight_segments (airline_name);
CREATE INDEX index_flight_segments_on_aircraft_bts_code ON flight_segments (aircraft_bts_code);
CREATE INDEX index_flight_segments_on_aircraft_description ON flight_segments (aircraft_description);
CREATE INDEX index_flight_segments_on_year ON flight_segments (year)

EOS

  self.primary_key = "row_hash"
  
  # Enable flight_segment.aircraft
  cache_fuzzy_match_with :aircraft, :primary_key => :aircraft_description, :foreign_key => :description
  
  class << self
    def update_averages!
      # Derive load factor, which is passengers divided by available seats
      where('seats > 0').update_all 'load_factor = 1.0 * passengers / seats'
      
      # Assume a load factor of 1 where passengers > available seats
      where('passengers > seats AND seats > 0').update_all 'load_factor = 1'
      
      # Derive freight share as a fraction of the total weight carried -- assume 90.718474 kg (200 lbs) per passenger (includes checked baggage)
      # FIXME TODO assume 100 kg per passenger?
      where('(freight + mail + passengers) > 0').update_all 'freight_share = 1.0 * (freight + mail) / (freight + mail + (passengers * 90.718474))'
      
      # Derive average seats per flight
      where('flights > 0').update_all 'seats_per_flight = 1.0 * seats / flights'
    end
  end
  
  def airline
    if airline_bts_code
      Airline.where(:bts_code => airline_bts_code).first
    else
      Airline.where(:icao_code => airline_icao_code).first
    end
  end
  
  falls_back_on :distance         => lambda { weighted_average(:distance,         :weighted_by => :passengers) }, # 2077.1205         data1 10-12-2010
                :seats_per_flight => lambda { weighted_average(:seats_per_flight, :weighted_by => :passengers) }, # 144.15653537046   data1 10-12-2010
                :load_factor      => lambda { weighted_average(:load_factor,      :weighted_by => :passengers) }, # 0.78073233770097  data1 10-12-2010
                :freight_share    => lambda { weighted_average(:freight_share,    :weighted_by => :passengers) }  # 0.022567224170157 data1 10-12-2010
  
  # FIXME remove this - wherever you're trying to create a flight segment, just don't use mass-assignment for the primary key
  attr_accessible :row_hash
  
  warn_if_nulls_except(
    :origin_airport_city,
    :destination_airport_city,
    :airline_icao_code,
    :load_factor,
    :freight_share
  )
  
  warn_unless_size 1_321_586..1_830_000
end
