schema Earth.database_options do
  string  'row_hash'                          # auto-generated primary key
  string  'origin_airport_iata_code'          # iata code
  string  'origin_country_iso_3166_code'      # iso code
  string  'destination_airport_iata_code'     # iata code
  string  'destination_country_iso_3166_code' # iso code
  string  'airline_iata_code'                 # bts code
  string  'aircraft_bts_code'                 # bts code
  integer 'departures_performed'              # number of flights over month
  integer 'passengers'                        # total passengers on all flights
  integer 'total_seats'                       # total seats on all flights
  float   'seats'                             # average seats per flight
  float   'load_factor'                       # passengers / seats
  float   'freight_share'                     # (freight + mail) / (freight + mail + (passengers * average passenger weight))
  float   'distance'                          # flight distance
  string  'distance_units'                    # 'kilometres'
  float   'payload'                           # aircraft maximum payload capacity rating; float b/c unit conversion
  string  'payload_units'                     # 'kilograms'
  float   'freight'                           # total freight on all flights performed; float b/c unit conversion
  string  'freight_units'                     # 'kilograms'
  float   'mail'                              # total mail on all flights performed; float b/c unit conversion
  string  'mail_units'                        # 'kilograms'
  integer 'month'                             # month of flight
  integer 'quarter'                           # quarter of flight
  integer 'year'                              # year of flight
  date    'approximate_date'                  # assumed 14th day of month
  index   'origin_airport_iata_code'          # index for faster lookup by origin
  index   'destination_airport_iata_code'     # index for faster lookup by destination
  index   'airline_iata_code'                 # index for faster lookup by airline
  index   'aircraft_bts_code'                 # index for faster lookup by aircraft
end
