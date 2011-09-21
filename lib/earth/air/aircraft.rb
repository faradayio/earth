class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  belongs_to :aircraft_class,    :foreign_key => 'class_code',    :primary_key => 'code'
  belongs_to :fuel_use_equation, :foreign_key => 'fuel_use_code', :primary_key => 'code', :class_name => 'AircraftFuelUseEquation'
  
  col :icao_code
  col :manufacturer_name
  col :model_name
  col :description
  col :aircraft_type
  col :engine_type
  col :engines, :type => :integer
  col :weight_class
  col :class_code
  col :fuel_use_code
  col :seats, :type => :float
  col :passengers, :type => :float
  
  # Enable aircraft.flight_segments
  cache_loose_tight_dictionary_matches_with :flight_segments, :primary_key => :description, :foreign_key => :aircraft_description

  class << self
    # set up a loose_tight_dictionary for matching Aircraft description with FlightSegment aircraft_description
    def loose_tight_dictionary
      @loose_tight_dictionary ||= LooseTightDictionary.new(Aircraft.all,
          :haystack_reader => lambda { |record| record.description },
          :blockings  => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=0&output=csv').map { |record| record['blocking'] },
          :identities => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=1&output=csv').map { |record| record['identity'] },
          :tighteners => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=2&output=csv').map { |record| record['tightener'] },
          :must_match_blocking => true,
          :first_blocking_decides => true)
    end
  
    # FIXME TODO do we want to restrict this to certain years?
    # Derive some average characteristics from flight segments
    def update_averages!
      manually_cache_flight_segments!
      find_each do |aircraft|
        aircraft.seats = aircraft.flight_segments.weighted_average :seats_per_flight, :weighted_by => :passengers
        aircraft.passengers = aircraft.flight_segments.sum :passengers
        aircraft.save!
      end
    end
  
    # Cache fuzzy matches between FlightSegment aircraft_description and Aircraft description
    def manually_cache_flight_segments!
      FlightSegment.run_data_miner!
      LooseTightDictionary::CachedResult.setup
      connection.select_values("SELECT DISTINCT(aircraft_description) FROM flight_segments WHERE aircraft_description IS NOT NULL").each do |original_description|
        # If the flight segment's aircraft_description contains '/' then it describes multiple aircraft.
        # We need to synthesize descriptions for those aircraft, find all Aircraft that fuzzily match the
        # synthesized descriptions, and associate those Aircraft with the original aircraft_description.
        # e.g. boeing 747-100/200
        if original_description.include?('/')
          # Pull out the complete first aircraft description
          # e.g. 'boeing 747-100'
          first_description = original_description.split('/')[0]
        
          # Pull out the root of the description - the text up to and including the last ' ' or '-'
          # e.g. 'boeing 747-'
          root_length = first_description.rindex(/[ \-]/)
          root = first_description.slice(0..root_length)
        
          # Pull out the suffixes - the text separated by forward slashes
          # e.g. ['100', '200']
          suffixes = original_description.split(root)[1].split('/')
        
          # Create an array of synthesized descriptions by appending each suffix to the root
          # e.g. ['boeing 747-100', 'boeing 747-200']
          suffixes.map{ |suffix| root + suffix }.each do |synthesized_description|
            # Look up the Aircraft that match each synthesized description and associate
            # them with the original flight segment aircraft_description
            Aircraft.loose_tight_dictionary.find_all(synthesized_description).each do |aircraft|
              attrs = {
                :a_class => "Aircraft",
                :a => aircraft.description,
                :b_class => "FlightSegment",
                :b => original_description
              }
              unless ::LooseTightDictionary::CachedResult.exists? attrs
                ::LooseTightDictionary::CachedResult.create! attrs
              end
            end
          end
        # If the flight segment's aircraft_description doesn't contain '/' we can use
        # a method provided by loose_tight_dictionary to associate it with Aircraft
        else
          FlightSegment.find_by_aircraft_description(original_description).cache_aircraft!
        end
      end
    end
  end
end