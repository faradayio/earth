Aircraft.class_eval do
  # For errata
  class Aircraft::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A([a-z]+)_is_(?:not_)?([^\?]+)/
        column_name = $1
        value = $2
        value_regexp = /^#{value.gsub('_',' ')}$/i
        # row['Manufacturer'] =~ /mcdonnell douglas/i
        matches = value_regexp.match(args.first[column_name.titleize])
        method_id.to_s.include?('_not_') ? matches.nil? : !matches.nil?
      else
        super
      end
    end
  end
  
  # We're only interested in aircraft from certain manufacturers
  def self.manufacturer_whitelist?(candidate)
    @manufacturer_whitelist ||= RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdFRFalpOdlg1cnF6amlSM1dDc1lya2c&output=csv').map { |record| record['Manufacturer'].to_regexp }
    @manufacturer_whitelist.any? { |manufacturer_regexp| manufacturer_regexp.match candidate }
  end
  
  data_miner do
    schema Earth.database_options do
      string  'icao_code'
      string  'manufacturer_name'
      string  'model_name'
      string  'description'
      string  'aircraft_type'
      string  'engine_type'
      integer 'engines'
      string  'weight_class'
      string  'class_code'
      string  'fuel_use_code'
      float   'seats'
      float   'passengers'
    end
    
    ('A'..'Z').each do |letter|
      import("aircraft made by whitelisted manufacturers whose ICAO code starts with '#{letter}' from the FAA",
             :url => "http://www.faa.gov/air_traffic/publications/atpubs/CNT/5-2-#{letter}.htm",
             :encoding => 'windows-1252',
             :row_xpath => '//table/tr[2]/td/table/tr',
             :column_xpath => 'td',
             :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGVBRnhkRGhSaVptSDJ5bXJGbkpUSWc&output=csv', :responder => Aircraft::Guru.new },
             :select => lambda { |record| manufacturer_whitelist? record['Manufacturer'] }) do
        key 'icao_code',           :field_name => 'Designator'
        store 'manufacturer_name', :field_name => 'Manufacturer'
        store 'model_name',        :field_name => 'Model'
        store 'aircraft_type',     :field_name => 'Type/Wt Class', :chars => 0, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDJtU0stS0duR1NhQVVIU29valYwREE&output=csv'}
        store 'engine_type',       :field_name => 'Type/Wt Class', :chars => 2, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHgtS0xRTERpbjAxSzBBNFc4LUJEMXc&output=csv'}
        store 'engines',           :field_name => 'Type/Wt Class', :chars => 1
        store 'weight_class',      :field_name => 'Type/Wt Class', :split => { :pattern => %r{/}, :keep => 1 }, :dictionary => {:input => 'code', :output => 'description', :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGhrWElDZ25oV2NPREg0eUhjRVRYUHc&output=csv'}
      end
    end
    
    import "aircraft not included in the FAA database",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRNaVpSUWw2Z2VhN3RUV25yYWdQX2c&output=csv' do
      key 'icao_code'
      store 'manufacturer_name'
      store 'model_name'
      store 'aircraft_type'
      store 'engine_type'
      store 'engines'
      store 'weight_class'
    end
    
    import "a curated list of aircraft fuel use codes",
           :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGxqRjFJdDlQWVVLYS11NnJVcDZsYWc&output=csv' do
      key 'icao_code'
      store 'fuel_use_code'
    end
    
    process "Synthesize description from manufacturer name and model name" do
      Aircraft.find_each do |aircraft|
        aircraft.update_attribute :description, [aircraft.manufacturer_name, aircraft.model_name].join(' ').downcase
      end
    end
    
    process "Synthesize class code from engine type and weight class" do
      Aircraft.find_each do |aircraft|
        size = case aircraft.weight_class
        when 'Small', 'Small+', 'Light'
          'Light'
        when 'Large', 'Medium'
          'Medium'
        else
          'Heavy'
        end
        aircraft.update_attribute :class_code, [size, aircraft.engines.to_s, 'engine', aircraft.engine_type].join(' ')
      end
    end
    
    process "Ensure FlightSegment is populated" do
      FlightSegment.run_data_miner!
    end
    
    process "Cache fuzzy matches between FlightSegment aircraft_description and Aircraft description" do
      LooseTightDictionary::CachedResult.setup
      FlightSegment.find_by_sql("SELECT DISTINCT aircraft_description FROM flight_segments WHERE aircraft_description IS NOT NULL").each do |flight_segment|
        original_description = flight_segment.aircraft_description
        
        # If the flight segment's aircraft_description contains '/' then it describes multiple aircraft.
        # We need to synthesize descriptions for those aircraft, find all Aircraft that fuzzily match the
        # synthesized descriptions, and associate those Aircraft with the original aircraft_description.
        # e.g. boeing 747-100/200
        if original_description.include?("/")
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
          flight_segment.cache_aircraft!
        end
      end
    end
    
    # FIXME TODO do we want to restrict this to certain years?
    process "Derive some average characteristics from flight segments" do
      Aircraft.find_each do |aircraft|
        aircraft.seats = aircraft.flight_segments.weighted_average :seats_per_flight, :weighted_by => :passengers
        aircraft.passengers = aircraft.flight_segments.sum :passengers
        aircraft.save
      end
    end
    
    # FIXME TODO verify this
  end
end
