class TestAircraftMatch < Test::Unit::TestCase
  def test_001_user_input_matches_icao_codes
    user_input = "Boeing 747-400"
    assert_equal ["B744", "B74D"], Aircraft.fuzzy_matches(user_input).map(&:icao_code)
  end
  
  def test_002_user_input_matches_icao_codes
    user_input = "Boeing 747SP"
    assert_equal ["B74S"], Aircraft.fuzzy_matches(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 747SP"
    assert_equal ["B74S"], Aircraft.fuzzy_matches(user_input).map(&:icao_code)
  end
  
  def test_004_user_input_matches_icao_codes
    user_input = "Boeing 727 Stage 3"
    assert_equal ["B72Q"], Aircraft.fuzzy_matches(user_input).map(&:icao_code)
  end
  
  def test_005_user_input_matches_icao_codes
    user_input = "Boeing 747"
    assert_equal ["B741", "B742", "B743", "B744", "B74D", "B74R", "B74S"], Aircraft.fuzzy_matches(user_input).map(&:icao_code)
  end
  
  # def test_001_flight_segments_match_icao_codes
  #   flight_segment_bts_aircraft_type_description = 'BOEING 747-100' # aka type 816
  #   assert_equal %w{ B741 B742 B743 B744 B74D B74R B74S }, Aircraft.loose_tight_dictionary(flight_segment_bts_aircraft_type_description).map(&:icao_code)
  # end
  # 
  # def test_003_user_input_matches_flight_segments
  #   user_input = '747'
  #   aircraft_suggested_by_user_input = Aircraft.loose_tight_dictionary(user_input)
  # 
  #   # this is why the following query should work...
  #   # FlightSegment.cohort(:aircraft => [ B731, B732 ])
  #   # FlightSegment => FuzzyAircraftMatch <= Aircraft
  #   # select * from flight_segments
  #   # inner join
  #   # fuzzy_aircraft_matches on
  #   # flight_segments.aircraft_description = fuzzy_aircraft_matches.bbb # FlightSegment.has_many :aircraft [...] :foreign_key => :bbb
  #   # where
  #   # fuzzy_aircraft_matches.aaa in ('B731', 'B732') # Aircraft.has_many :aircraft [...] :foreign_key => :aaa
  #   
  #   assert_equal [...flight segments...], FlightSegment.cohort(:aircraft => aircraft_suggested_by_user_input)
  # end
  # 
  # def test_004_user_input_matches_fuel_use_equations
  #   user_input = '747'
  #   aircraft_suggested_by_user_input = Aircraft.loose_tight_dictionary(user_input)
  # 
  #   # see above for why this would work
  #   # ...
  #   # fuel_use_equations.aircraft_description = fuzzy_aircraft_matches.bbb # FuelUseEquation.has_many :aircraft [...] :foreign_key => :bbb
  #   # ...
  # 
  #   assert_equal [...flight segments...], FuelUseEquation.cohort(:aircraft => aircraft_suggested_by_user_input)
  # end
end