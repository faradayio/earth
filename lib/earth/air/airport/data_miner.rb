Airport.class_eval do
  class Airport::Guru
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
    import "the OpenFlights.org airports database",
           :url => 'https://openflights.svn.sourceforge.net/svnroot/openflights/openflights/data/airports.dat',
           :headers => %w{ id name city country_name iata_code icao_code latitude longitude altitude timezone daylight_savings },
           :select => lambda { |record| record['iata_code'].present? },
           :errata => { :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFc2UzhQYU5PWEQ0N21yWFZGNmc2a3c&gid=0&output=csv',
                        :responder => Airport::Guru.new } do
      key 'iata_code'
      store 'name'
      store 'city'
      store 'country_name'
      store 'latitude'
      store 'longitude'
    end
    
    import "airports missing from the OpenFlights.org database",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHpyR3NudEl5V21ZcEdXQXFDNU8zTWc&output=csv' do
      key 'iata_code'
      store 'name'
      store 'city'
      store 'country_name'
      store 'latitude'
      store 'longitude'
    end
    
    process "Ensure Country is populated" do
      Country.run_data_miner!
    end
    
    process "Fill in blank country codes" do
      Country.find_each do |country|
        next unless country.name.present? and country.iso_3166_code.present?
        where(["country_name LIKE ?", country.name]).update_all :country_iso_3166_code => country.iso_3166_code
      end
    end
    
    # 10/14/2011 cutting this b/c we don't use it - Ian
    # sabshere 5/24/10 using temporary tables because the WHERE clause has a very slow OR condition: iata_code = destination_iata_code OR iata_code = origin_iata_code
    # process "Derive some average flight characteristics from flight segments" do
    #   FlightSegment.run_data_miner!
    #   segments = FlightSegment.arel_table
    #   airports = Airport.arel_table
    #   
    #   find_in_batches do |batch|
    #     batch.each do |airport|
    #       targeting_relation = airports[:iata_code].eq airport.iata_code
    #       conditional_relation = segments[:origin_airport_iata_code].eq(airport.iata_code).or(segments[:destination_airport_iata_code].eq(airport.iata_code))
    #       connection.execute "CREATE TEMPORARY TABLE tmp1 #{FlightSegment.where(conditional_relation).to_sql}"
    #       update_all "seats                    = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
    #       update_all "distance                 = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
    #       update_all "load_factor              = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
    #       update_all "freight_share            = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
    #       update_all "payload                  = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
    #       connection.execute 'DROP TABLE tmp1'
    #     end
    #   end
    # end
    
    # FIXME TODO verify this
  end
end
