class FuzzyAircraftMatch < ActiveRecord::Base
  belongs_to :aircraft,          :foreign_key => 'icao_code',   :primary_key => 'icao_code'
  belongs_to :flight_segment,    :foreign_key => 'description', :primary_key => 'aircraft_description'
  belongs_to :fuel_use_equation, :foreign_key => 'description', :primary_key => 'aircraft_description', :class_name => 'AircraftFuelUseEquation'
  
  class << self
    # create records linking the icao codes of all aircraft whose description is similar to seach_description with search_description
    def populate!(search_description)
      Aircraft.fuzzy_matches(search_description).each do |aircraft|
        find_or_create_by_icao_code_and_description_and_search_description(aircraft.icao_code, aircraft.description, search_description)
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
