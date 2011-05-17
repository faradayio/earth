class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  belongs_to :aircraft_class,    :foreign_key => 'class_code',    :primary_key => 'code'
  belongs_to :fuel_use_equation, :foreign_key => 'fuel_use_code', :primary_key => 'code', :class_name => 'AircraftFuelUseEquation'
  
  # associate each aircraft with aircraft similar to itself via fuzzy matches
  # FIXME TODO is this necessary?
  has_many :fuzzy_aircraft_matches, :foreign_key => 'icao_code', :primary_key => 'icao_code'
  has_many :flight_segments, :through => :fuzzy_aircraft_matches
  
  def self.ltd
    @ltd ||= LooseTightDictionary.new(Aircraft.all, :haystack_reader => lambda { |record| record.description },
                                                    :blockings => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=0&output=csv').map { |record| record['blocking'] },
                                                    :identities => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=1&output=csv').map { |record| record['identity'] },
                                                    :tighteners => RemoteTable.new(:url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDlRR2NmdzE2ZjZwTy1ucjh4cWFYOFE&gid=2&output=csv').map { |record| record['tightener'] },
                                                    :must_match_blocking => true,
                                                    :first_blocking_decides => true)
  end
  
  # find every aircraft whose name is similar to search_name
  def self.fuzzy_matches(search_description)
    ltd.find_all search_description.downcase
  end
  
  data_miner do
    tap "Brighter Planet's sanitized aircraft data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
