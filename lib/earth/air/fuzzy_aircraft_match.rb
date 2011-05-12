class FuzzyAircraftMatch < ActiveRecord::Base
  belongs_to :aircraft, :foreign_key => 'icao_code',            :primary_key => 'icao_code'
  has_many :flight_segments, :foreign_key => 'aircraft_description', :primary_key => 'search_description'
  
  class << self
    # Create records linking a search descriptoin with the icao codes of all aircraft whose description is similar to seach_description
    def populate!(search_description)
      # If the search description describes multiple variants, split it into a base and several suffixes
      # e.g. 'boeing 747-100/200/300' => ['boeing 747-', '100', '200', '300']
      if /\//.match(search_description)
        base_and_first_suffix = search_description.split('/')[0]
        base_length = base_and_first_suffix.rindex(/[ \-]/i)
        base = base_and_first_suffix.slice(0..base_length)
        suffixes = search_description.split(base)[1].split('/')
        
        # Combine each suffix with the base to get a list of complete model ids
        # e.g. ['boeing 747-100', 'boeing 747-200', 'boeing 747-300']
        synthetic_descriptions = suffixes.map { |suffix| base + suffix }
        
        # Find the fuzzy matches for every complete model id and associate them all with the original search description
        # e.g. 'boeing 747-100/200/300' => [B741, B742, B743]
        synthetic_descriptions.each do |synthetic_description|
          Aircraft.fuzzy_matches(synthetic_description).each do |aircraft|
            FuzzyAircraftMatch.find_or_create_by_icao_code_and_description_and_search_description(aircraft.icao_code, aircraft.description, search_description)
          end
        end
      # If the search description describes a single variant, find and remember the fuzzy matches
      # e.g. 'boeing 747-400' => ['B744', 'B74D']
      else
        Aircraft.fuzzy_matches(search_description).each do |aircraft|
          FuzzyAircraftMatch.find_or_create_by_icao_code_and_description_and_search_description(aircraft.icao_code, aircraft.description, search_description)
        end
      end
    end
  end
  
  data_miner do
    tap "Brighter Planet's sanitized airports data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
