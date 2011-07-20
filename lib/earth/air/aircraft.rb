class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  belongs_to :aircraft_class,    :foreign_key => 'class_code',    :primary_key => 'code'
  belongs_to :fuel_use_equation, :foreign_key => 'fuel_use_code', :primary_key => 'code', :class_name => 'AircraftFuelUseEquation'
  
  # set up a loose_tight_dictionary for matching Aircraft description with FlightSegment aircraft_description
  class << self
    def loose_tight_dictionary
      @loose_tight_dictionary ||= LooseTightDictionary.new(Aircraft.all,
          :haystack_reader => lambda { |record| record.description },
          :blockings  => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=0&output=csv').map { |record| record['blocking'] },
          :identities => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=1&output=csv').map { |record| record['identity'] },
          :tighteners => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=2&output=csv').map { |record| record['tightener'] },
          :must_match_blocking => true,
          :first_blocking_decides => true)
    end
  end
  
  force_schema do
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
  
  # Enable aircraft.flight_segments
  cache_loose_tight_dictionary_matches_with :flight_segments, :primary_key => :description, :foreign_key => :aircraft_description
end
