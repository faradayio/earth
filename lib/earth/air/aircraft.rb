require 'fuzzy_match/cached_result'

class Aircraft < ActiveRecord::Base
  self.primary_key = "icao_code"
  
  # Fuzzy association with FlightSegment
  cache_fuzzy_match_with :flight_segments, :primary_key => :description, :foreign_key => :aircraft_description
  
  class << self
    # set up a fuzzy_match for matching Aircraft description with FlightSegment aircraft_description
    def fuzzy_match
      @fuzzy_match ||= FuzzyMatch.new(Aircraft.all,
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
      # Setup fuzzy matches with FlightSegment
      manually_cache_flight_segments!
      
      # Calculate seats and passengers for each aircraft based on associated flight_segments
      find_each do |a|
        if a.seats = a.flight_segments.weighted_average(:seats_per_flight, :weighted_by => :passengers)
          a.seats_specificity = 'aircraft'
        end
        if (passengers = a.flight_segments.sum(:passengers)) > 0
          a.passengers = passengers
        end
        a.save!
      end
      
      # Calculate seats for any aircraft that don't have any flight_segments by averaging across all aircraft with flight segments in the aircraft class
      where(:seats => nil).find_each do |a|
        if a.seats = where(:class_code => a.class_code, :seats_specificity => 'aircraft').weighted_average(:seats, :weighted_by => :passengers)
          a.seats_specificity = 'aircraft_class'
          a.save!
        end
      end
      
      # Calculate any missing fuel use coefficients by averaging across all aircraft with fuel use coefficients in the same aircraft class
      where(:m3 => nil).find_each do |a|
        a.m3 = where(:class_code => a.class_code, :fuel_use_specificity => 'aircraft').weighted_average(:m3, :weighted_by => :passengers)
        a.m2 = where(:class_code => a.class_code, :fuel_use_specificity => 'aircraft').weighted_average(:m2, :weighted_by => :passengers)
        a.m1 = where(:class_code => a.class_code, :fuel_use_specificity => 'aircraft').weighted_average(:m1, :weighted_by => :passengers)
        a.b =  where(:class_code => a.class_code, :fuel_use_specificity => 'aircraft').weighted_average(:b,  :weighted_by => :passengers)
        if a.valid_fuel_use_equation?
          a.m3_units = 'kilograms_per_cubic_nautical_mile'
          a.m2_units = 'kilograms_per_square_nautical_mile'
          a.m1_units = 'kilograms_per_nautical_mile'
          a.b_units =  'kilograms'
          a.fuel_use_specificity = 'aircraft_class'
          a.save!
        end
      end
    end
    
    # Cache fuzzy matches between FlightSegment aircraft_description and Aircraft description
    def manually_cache_flight_segments!
      FlightSegment.run_data_miner!
      FuzzyMatch::CachedResult.auto_upgrade!
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
            Aircraft.fuzzy_match.find_all(synthesized_description).each do |aircraft|
              attrs = {
                :a_class => "Aircraft",
                :a => aircraft.description,
                :b_class => "FlightSegment",
                :b => original_description
              }
              unless ::FuzzyMatch::CachedResult.exists? attrs
                ::FuzzyMatch::CachedResult.create! attrs
              end
            end
          end
        # If the flight segment's aircraft_description doesn't contain '/' we can use
        # a method provided by fuzzy_match to associate it with Aircraft
        else
          FlightSegment.find_by_aircraft_description(original_description).cache_aircraft!
        end
      end
    end
  end
  
  def valid_fuel_use_equation?
    [m3, m2, m1, b].all?(&:present?) and [m3, m2, m1, b].any?(&:nonzero?)
  end
  
  falls_back_on :m3 => lambda { weighted_average(:m3, :weighted_by => :passengers) }, # 9.73423082858437e-08   r7110: 8.6540464368905e-8      r6972: 8.37e-8
                :m2 => lambda { weighted_average(:m2, :weighted_by => :passengers) }, # -0.000134350543484608  r7110: -0.00015337661447817    r6972: -4.09e-5
                :m1 => lambda { weighted_average(:m1, :weighted_by => :passengers) }, # 6.7728101555467        r7110: 4.7781966869412         r6972: 7.85
                :b  => lambda { weighted_average(:b,  :weighted_by => :passengers) }, # 1527.81790006167       r7110: 1065.3476555284         r6972: 1.72e3
                :m3_units => 'kilograms_per_cubic_nautical_mile',
                :m2_units => 'kilograms_per_square_nautical_mile',
                :m1_units => 'kilograms_per_nautical_mile',
                :b_units  => 'kilograms'
  
  col :icao_code
  col :manufacturer_name
  col :model_name
  col :description
  col :aircraft_type
  col :engine_type
  col :engines, :type => :integer
  col :weight_class
  col :class_code
  col :passengers, :type => :float
  col :seats, :type => :float
  col :seats_specificity
  col :m3, :type => :float
  col :m3_units
  col :m2, :type => :float
  col :m2_units
  col :m1, :type => :float
  col :m1_units
  col :b, :type => :float
  col :b_units
  col :fuel_use_specificity

  warn_if_nulls_except(
    :passengers,
    :seats,
    :seats_specificity,
    :m3,
    :m3_units,
    :m2,
    :m2_units,
    :m1,
    :m1_units,
    :b,
    :b_units,
    :fuel_use_specificity
  )

  warn_unless_size 437
end
