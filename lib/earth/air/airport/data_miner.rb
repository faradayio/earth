Airport.class_eval do
  class Airport::Guru
    def iata_missing?(row)
      row['iata_code'].nil?
    end
    
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A(id|iata)_is_([a-z]{3}|\d{1,4})\?$/
        regexp = Regexp.new($2, Regexp::IGNORECASE)
        if $1 == "iata"
          args.first['iata_code'] =~ regexp # row['iata_code'] =~ /meh/i
        else
          args.first[$1] =~ regexp # row['id'] =~ /1234/i
        end
      else
        super
      end
    end
  end
  
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
           :url => 'https://openflights.svn.sourceforge.net/svnroot/openflights/openflights/data/airports.dat',
           :headers => %w{ id name city country_name iata_code icao_code latitude longitude altitude timezone daylight_savings },
           :errata => { :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFc2UzhQYU5PWEQ0N21yWFZGNmc2a3c&gid=0&output=csv',
                        :responder => Airport::Guru.new } do
      key 'iata_code'
      store 'name'
      store 'city'
      store 'country_name'
      store 'country_iso_3166_code', :field_name => 'country_name', :upcase => true, :dictionary => { :input => 'name', :output => 'iso_3166_code', :url => 'http://data.brighterplanet.com/countries.csv' }
      store 'latitude'
      store 'longitude'
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
      update_all 'international_origin = 1','(SELECT COUNT(*) FROM flight_segments WHERE flight_segments.origin_airport_iata_code = airports.iata_code AND flight_segments.origin_country_iso_3166_code != flight_segments.destination_country_iso_3166_code AND flight_segments.origin_country_iso_3166_code IS NOT NULL AND flight_segments.destination_country_iso_3166_code IS NOT NULL LIMIT 1) > 0'
      update_all 'international_destination = 1', '(SELECT COUNT(*) FROM flight_segments WHERE flight_segments.destination_airport_iata_code   = airports.iata_code AND flight_segments.origin_country_iso_3166_code != flight_segments.destination_country_iso_3166_code AND flight_segments.origin_country_iso_3166_code IS NOT NULL AND flight_segments.destination_country_iso_3166_code IS NOT NULL LIMIT 1) > 0'
    end
    
    # sabshere 5/24/10 using temporary tables because the WHERE clause has a very slow OR condition: iata_code = destination_iata_code OR iata_code = origin_iata_code
    process "Derive some average flight characteristics from flight segments" do
      FlightSegment.run_data_miner!
      segments = FlightSegment.arel_table
      airports = Airport.arel_table
      
      find_in_batches do |batch|
        batch.each do |airport|
          targeting_relation = airports[:iata_code].eq airport.iata_code
          conditional_relation = segments[:origin_airport_iata_code].eq(airport.iata_code).or(segments[:destination_airport_iata_code].eq(airport.iata_code))
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
    
    # FIXME TODO verify this
  end
end
