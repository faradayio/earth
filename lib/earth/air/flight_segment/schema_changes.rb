schema Earth.database_options do
  string  'row_hash'                          # auto-generated primary key
  string  'origin_designator'                 # iata code or city
  string  'origin_designator_type'            # 'iata_code' or 'city'
  string  'origin_country_iso_3166_code'      # iso code
  string  'destination_designator'            # iata code or city
  string  'destination_designator_type'       # 'iata_code' or 'city'
  string  'destination_country_iso_3166_code' # iso code
  string  'airline_designator'                # bts code or icao code
  string  'airline_designator_type'           # 'bts_code' or 'icao_code'
  string  'aircraft_description'              # text description from BTS T-100 or ICAO TFS
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
  index   'origin_designator'                 # index for faster lookup by origin
  index   'destination_designator'            # index for faster lookup by destination
  index   'airline_designator'                # index for faster lookup by airline
  index   'aircraft_description'              # index for faster lookup by aircraft
end
