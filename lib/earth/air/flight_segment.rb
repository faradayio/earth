# need this for association with Aircraft through loose_tight_dictionary_cached_results
require 'loose_tight_dictionary/cached_result'

class FlightSegment < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 1
  
  # If airport iata code is present, associate with a single airport
  belongs_to :origin_airport,      :foreign_key => 'origin_airport_iata_code',      :primary_key => 'iata_code', :class_name => 'Airport'
  belongs_to :destination_airport, :foreign_key => 'destination_airport_iata_code', :primary_key => 'iata_code', :class_name => 'Airport'
  
  # If airport iata code is missing, associate with all airports in a city
  has_many :origin_city_airports,      :foreign_key => 'city', :primary_key => 'origin_airport_city',      :class_name => 'Airport'
  has_many :destination_city_airports, :foreign_key => 'city', :primary_key => 'destination_airport_city', :class_name => 'Airport'
  
  # Associate with Airline based on airline name
  belongs_to :airline, :foreign_key => 'airline_name', :primary_key => 'name'
  
  # Return an array of descriptions if the original aircraft_description describes multiple aircraft
  # e.g. 'boeing 747-100/200/300' => ['boeing 747-100', 'boeing 747-200', 'boeing 747-300']
  def aircraft_description
    original_description = read_attribute :aircraft_description
    
    # If the original aircraft_description contains '/' then it describes multiple aircraft
    # e.g. 'boeing 747-100/200/300'
    if /\//.match(original_description)
      # Pull out the complete first aircraft description
      # e.g. 'boeing 747-100'
      base_and_first_suffix = original_description.split('/')[0]
      
      # Pull out the base description - the text up to and including the last space or dash
      # e.g. 'boeing 747-'
      base_length = base_and_first_suffix.rindex(/[ \-]/i)
      base = base_and_first_suffix.slice(0..base_length)
      
      # Pull out the suffixes - the text separated by forward slashes
      # e.g. ['100', '200', '300']
      suffixes = original_description.split(base)[1].split('/')
      
      # Return an array of each suffix appended to the base
      # e.g. ['boeing 747-100', 'boeing 747-200', 'boeing 747-300']
      suffixes.map { |suffix| base + suffix }
    
    # Otherwise return the original aircraft_description
    else
      original_description
    end
  end
  
  # Enable flight_segment.aircraft
  cache_loose_tight_dictionary_matches_with :aircraft, :primary_key => :aircraft_description, :foreign_key => :description
  
  falls_back_on :distance         => lambda { weighted_average(:distance,         :weighted_by => :passengers) }, # 2077.1205         data1 10-12-2010
                :seats_per_flight => lambda { weighted_average(:seats_per_flight, :weighted_by => :passengers) }, # 144.15653537046   data1 10-12-2010
                :load_factor      => lambda { weighted_average(:load_factor,      :weighted_by => :passengers) }, # 0.78073233770097  data1 10-12-2010
                :freight_share    => lambda { weighted_average(:freight_share,    :weighted_by => :passengers) }  # 0.022567224170157 data1 10-12-2010
  
  data_miner do
    tap "Brighter Planet's sanitized flight segment data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
