# need this for association with Aircraft through loose_tight_dictionary_cached_results
require 'loose_tight_dictionary'

class FlightSegment < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 1
  
  # If airport iata code is missing, associate with all airports in a city
  # We need this to calculate distance when importing ICAO segments - see cm1 flight_segment.rb
  has_many :origin_city_airports,      :foreign_key => 'city', :primary_key => 'origin_airport_city',      :class_name => 'Airport'
  has_many :destination_city_airports, :foreign_key => 'city', :primary_key => 'destination_airport_city', :class_name => 'Airport'
  
  # Enable flight_segment.aircraft
  cache_loose_tight_dictionary_matches_with :aircraft, :primary_key => :aircraft_description, :foreign_key => :description
  
  falls_back_on :distance         => lambda { weighted_average(:distance,         :weighted_by => :passengers) }, # 2077.1205         data1 10-12-2010
                :seats_per_flight => lambda { weighted_average(:seats_per_flight, :weighted_by => :passengers) }, # 144.15653537046   data1 10-12-2010
                :load_factor      => lambda { weighted_average(:load_factor,      :weighted_by => :passengers) }, # 0.78073233770097  data1 10-12-2010
                :freight_share    => lambda { weighted_average(:freight_share,    :weighted_by => :passengers) }  # 0.022567224170157 data1 10-12-2010
  
  create_table do
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
    float   'seats_per_flight'                  # average seats per flight; make this a float
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
end
