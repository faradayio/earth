class FlightSegment < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 1
  
  # Cutting this for now because if iata code is missing we have to look up airports using both city and country; don't know how to do this with ActiveRecord
  # - Ian 6/12/2011
  # # If airport iata code is missing, associate with all airports in a city
  # # We need this to calculate distance when importing ICAO segments - see cm1 flight_segment.rb
  # has_many :origin_city_airports,      :foreign_key => 'city', :primary_key => 'origin_airport_city',      :class_name => 'Airport'
  # has_many :destination_city_airports, :foreign_key => 'city', :primary_key => 'destination_airport_city', :class_name => 'Airport'
  
  # Enable flight_segment.aircraft
  cache_loose_tight_dictionary_matches_with :aircraft, :primary_key => :aircraft_description, :foreign_key => :description
  
  falls_back_on :distance         => lambda { weighted_average(:distance,         :weighted_by => :passengers) }, # 2077.1205         data1 10-12-2010
                :seats_per_flight => lambda { weighted_average(:seats_per_flight, :weighted_by => :passengers) }, # 144.15653537046   data1 10-12-2010
                :load_factor      => lambda { weighted_average(:load_factor,      :weighted_by => :passengers) }, # 0.78073233770097  data1 10-12-2010
                :freight_share    => lambda { weighted_average(:freight_share,    :weighted_by => :passengers) }  # 0.022567224170157 data1 10-12-2010
  
  col :row_hash                          # auto-generated primary key
  col :origin_airport_iata_code          # iata code
  col :origin_airport_city               # city
  col :origin_country_iso_3166_code      # iso code
  col :destination_airport_iata_code     # iata code
  col :destination_airport_city          # city
  col :destination_country_iso_3166_code # iso code
  col :airline_bts_code                  # bts code
  col :airline_icao_code                 # icao code
  col :airline_name                      # text description derived from bts or icao code
  col :aircraft_bts_code                 # bts code
  col :aircraft_description              # text description derived from BTS T100 or ICAO TFS
  col :flights, :type => :integer                           # number of flights over month or year
  col :passengers, :type => :integer                        # total passengers on all flights
  col :seats, :type => :integer                             # total seats on all flights
  col :seats_per_flight, :type => :float                  # average seats per flight; make this a float
  col :load_factor, :type => :float                       # passengers / seats
  col :freight_share, :type => :float                     # (freight + mail) / (freight + mail + (passengers * average passenger weight))
  col :distance, :type => :float                          # flight distance
  col :distance_units                    # 'kilometres'
  col :payload_capacity, :type => :float                  # aircraft maximum payload capacity rating; float b/c unit conversion
  col :payload_capacity_units            # 'kilograms'
  col :freight, :type => :float                           # total freight on all flights performed; float b/c unit conversion
  col :freight_units                     # 'kilograms'
  col :mail, :type => :float                              # total mail on all flights performed; float b/c unit conversion
  col :mail_units                        # 'kilograms'
  col :month, :type => :integer                             # month of flight
  col :year, :type => :integer                              # year of flight
  col :approximate_date, :type => :date                  # assumed 14th day of month
  col :source                            # 'BTS T100' or 'ICAO TFS'
  add_index :origin_airport_iata_code
  add_index :origin_airport_city
  add_index :destination_airport_iata_code
  add_index :destination_airport_city
  add_index :airline_bts_code
  add_index :airline_icao_code
  add_index :airline_name
  add_index :aircraft_bts_code
  add_index :aircraft_description
  add_index :year
  
  def self.update_averages!
    # Derive load factor, which is passengers divided by available seats
    update_all 'load_factor = passengers / seats', 'seats > 0'

    # Assume a load factor of 1 where passengers > available seats
    update_all 'load_factor = 1', 'passengers > seats AND seats > 0'
  
    # TODO: what is 90.718474
    # Derive freight share as a fraction of the total weight carried
    update_all 'freight_share = (freight + mail) / (freight + mail + (passengers * 90.718474))', '(freight + mail + passengers) > 0'
  
    # Derive average seats per flight
    update_all 'seats_per_flight = seats / flights', 'flights > 0'
    
    # Add a useful date field
    update_all 'approximate_date = DATE(year || "-" || month || "-" || "14")', 'month IS NOT NULL'
  end
end