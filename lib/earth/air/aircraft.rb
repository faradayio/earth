class Aircraft < ActiveRecord::Base
  set_primary_key :icao_code
  
  belongs_to :aircraft_class, :foreign_key => 'class_code', :primary_key => 'code'
  
  # associate each aircraft with aircraft similar to itself via fuzzy matches
  # FIXME TODO is this necessary?
  has_many :fuzzy_aircraft_matches, :foreign_key => 'icao_code', :primary_key => 'icao_code'
  has_many :aircraft, :through => :fuzzy_aircraft_matches, :foreign_key => 'icao_code', :primary_key => 'icao_code'
  
  # for use in fuzzy matching - concatenate manufacturer name and model name
  def description
    manufacturer_name + " " + model_name
  end
  
  def self.ltd
    @ltd ||= LooseTightDictionary.new(Aircraft.all, :haystack_reader => lambda { |record| record.description.downcase },
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
  
  # blocking (when :must_match_blocking => true)
  # takes all blockings that match the needle
  # sifts through haystack, and only keeps straws that match those blockings
  # if the blocking includes captures then the match of the blocking on the straw must be the same as the match of the blocking on the needle
  # e.g. /(boeing \d{3})/i needle = "Boeing 747" straw1 = "Boeing 727" (rejected) straw2 = "Boeing 747-100" (kept)
  
  # identity
  # /(boeing).*(7\d)(0|7)/ only keeps straws whose match result of the identity is the same as the needle's match result of the identity
  # if identity doesn't match needle, it's ignored
  # if it matches needle but doesn't match straw, that straw is filtered out
  # if it matches needle and straw, if the match result of both is the same keep the straw; otherwise filter it out
  
  # tightening
  # /(douglas).*(md).*(\d\d)/ compares the match result, rather than the raw needle and straw
  # does this for all tightenings, and figures out which combination has the highest possible score
  # basically use this to get some things to have a better score than others
  # works on our pre-screened list of straws (that we get after running blockings and identities)
  
  data_miner do
    tap "Brighter Planet's sanitized aircraft data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
