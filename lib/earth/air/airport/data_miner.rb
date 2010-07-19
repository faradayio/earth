Airport.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'iata_code'
      string   'name'
      string   'city'
      string   'country_name'
      string   'country_iso_3166_code'
      float    'latitude'
      float    'longitude'
      float    'seats'
      float    'distance'
      string   'distance_units'
      float    'load_factor'
      float    'freight_share'
      float    'payload'
      string   'payload_units'
      boolean  'international_origin'
      boolean  'international_destination'
    end
    
    import "the OpenFlights.org airports database",
           :url => 'http://openflights.svn.sourceforge.net/viewvc/openflights/openflights/data/airports.dat',
           :headers => false,
           :select => lambda { |row| row[4].present? } do
      key   'iata_code', :field_number => 4
      store 'name', :field_number => 1
      store 'city', :field_number => 2
      store 'country_name', :field_number => 3
      store 'country_iso_3166_code', :field_number => 3, :upcase => true, :dictionary => { :input => 'name', :output => 'iso_3166_code', :url => 'http://data.brighterplanet.com/countries.csv' }
      store 'latitude', :field_number => 6
      store 'longitude', :field_number => 7
    end
    
    # step.await :other_class => FlightSegment do |deferred|
    #   deferred.derive :country # this uses a heuristic that depends on flight segments
    # class << self
    #   def derive_country
    #     update_all('country_id = (SELECT      flight_segments.origin_country_id FROM flight_segments WHERE      flight_segments.origin_airport_id = airports.id AND      flight_segments.origin_country_id IS NOT NULL LIMIT 1)', 'airports.country_id IS NULL')
    #     update_all('country_id = (SELECT flight_segments.destination_country_id FROM flight_segments WHERE flight_segments.destination_airport_id = airports.id AND flight_segments.destination_country_id IS NOT NULL LIMIT 1)', 'airports.country_id IS NULL')
    #     Country.all.each do |c|
    #       next if c.name.blank?
    #       update_all("country_id = #{c.id}", ["airports.country_id IS NULL AND airports.country_name LIKE ?", "%#{c.name.upcase}%"])
    #     end
    #     Airport.all(:conditions => 'country_id IS NULL AND country_name IS NOT NULL').each do |a|
    #       c = Country.find(:first, :conditions => ["name like ?", "%#{a.country_name}%"])
    #       a.update_attributes(:country_id => c.id) if c
    #     end
    #   end
    # end

    process "Determine whether each airport serves international flights" do
      FlightSegment.run_data_miner!
      update_all 'international_origin = 1',      '(SELECT COUNT(*) FROM flight_segments WHERE flight_segments.origin_airport_iata_code = airports.iata_code AND flight_segments.origin_country_iso_3166_code != flight_segments.dest_country_iso_3166_code AND flight_segments.origin_country_iso_3166_code IS NOT NULL AND flight_segments.dest_country_iso_3166_code IS NOT NULL LIMIT 1) > 0'
      update_all 'international_destination = 1', '(SELECT COUNT(*) FROM flight_segments WHERE flight_segments.dest_airport_iata_code   = airports.iata_code AND flight_segments.origin_country_iso_3166_code != flight_segments.dest_country_iso_3166_code AND flight_segments.origin_country_iso_3166_code IS NOT NULL AND flight_segments.dest_country_iso_3166_code IS NOT NULL LIMIT 1) > 0'
    end
    
    # sabshere 5/24/10 using temporary tables because the WHERE clause has a very slow OR condition: iata_code = dest_iata_code OR iata_code = origin_iata_code
    process "Derive some average flight characteristics from flight segments" do
      FlightSegment.run_data_miner!
      segments = FlightSegment.arel_table
      airports = Airport.arel_table

      find_in_batches do |batch|
        batch.each do |airport|
          targeting_relation = airports[:iata_code].eq airport.iata_code
          conditional_relation = segments[:origin_airport_iata_code].eq(airport.iata_code).or(segments[:dest_airport_iata_code].eq(airport.iata_code))
          connection.execute "CREATE TEMPORARY TABLE tmp1 #{FlightSegment.where(conditional_relation).to_sql}"
          update_all "seats                    = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "distance                 = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "load_factor              = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "freight_share            = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "payload                  = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          connection.execute 'DROP TABLE tmp1'
        end
      end
    end
  end
end

