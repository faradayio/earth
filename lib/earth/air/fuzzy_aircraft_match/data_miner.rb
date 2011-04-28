FuzzyAircraftMatch.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'icao_code'
      string 'description'
      string 'search_description'
    end
    
    # records are synthesized via FuzzyAircraftMatch.populate! calls in FlightSegment and AircraftFuelUseEquation
  end
end
