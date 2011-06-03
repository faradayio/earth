class TestAircraftMatch < Test::Unit::TestCase
  def test_014_user_input_matches_icao_codes
    user_input = "Boeing 727-100RE"
    assert_equal ["R721"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_015_user_input_matches_icao_codes
    user_input = "Boeing 727 200RE"
    assert_equal ["R722"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 747400 domestic"
    assert_equal ["B74D"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 777-200lr"
    assert_equal ["B77L"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 707-100"
    assert_equal ["B701"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 707-200"
    assert_equal ["B701", "B703"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 717-200"
    assert_equal ["B712"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 717-100"
    assert_equal ["B712"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 727-100"
    assert_equal ["B721"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 727-300"
    assert_equal ["B721", "B722"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_006_user_input_matches_icao_codes
    user_input = "Boeing 737-900"
    assert_equal ["B739"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_002_user_input_matches_icao_codes
    user_input = "Boeing 747-100"
    assert_equal ["B741"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_002_user_input_matches_icao_codes
    user_input = "Boeing 747-500"
    assert_equal ["B741", "B742", "B743", "B744", "B74D", "B74R", "B74S"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 757-200"
    assert_equal ["B752"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 757-100"
    assert_equal ["B752", "B753"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 767-200"
    assert_equal ["B762"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 767-100"
    assert_equal ["B762", "B763", "B764"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 777-200"
    assert_equal ["B772", "B77L"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 777-100"
    assert_equal ["B772", "B773", "B77L"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 727 Stage 3"
    assert_equal ["B72Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 737 Stage 3"
    assert_equal ["B73Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 737 Stage 4"
    assert_equal ["B731", "B732", "B733", "B734", "B735", "B736", "B737", "B738", "B739", "B73Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 747SP"
    assert_equal ["B74S"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 747 SR"
    assert_equal ["B74R"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 747SCA"
    assert_equal ["BSCA"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 747S"
    assert_equal ["B741", "B742", "B743", "B744", "B74D", "B74R", "B74S"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 720"
    assert_equal ["B720"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 707"
    assert_equal ["B701", "B703"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Boeing 787"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A300600"
    assert_equal ["A306"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A300 100"
    assert_equal ["A306", "A30B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A300-600st"
    assert_equal ["A3ST"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus Beluga"
    assert_equal ["A3ST"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A330-200"
    assert_equal ["A332"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A330-100"
    assert_equal ["A332", "A333"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A340-200"
    assert_equal ["A342"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A340-100"
    assert_equal ["A342", "A343", "A345", "A346"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A380-800"
    assert_equal ["A388"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A380-100"
    assert_equal ["A388"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A300C"
    assert_equal ["A30B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A300X"
    assert_equal ["A306", "A30B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A318"
    assert_equal ["A318"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A311"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A321"
    assert_equal ["A321"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A322"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Airbus A350"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CL601"
    assert_equal ["CL60"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CL215"
    assert_equal ["CL2P"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CL215 turbine"
    assert_equal ["CL2T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CL44O"
    assert_equal ["CL4G"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CRJ440"
    assert_equal ["CRJ2"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Canadair CRJ111"
    assert_equal ["CRJ1"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer ERJ130"
    assert_equal ["E135"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer ERJ145XR"
    assert_equal ["E45X"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer EMB110"
    assert_equal ["E110"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer Bandeirante"
    assert_equal ["E110"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer EMB120"
    assert_equal ["E120"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer Brasilia"
    assert_equal ["E120"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer EMB121"
    assert_equal ["E121"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer Xingu"
    assert_equal ["E121"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer EMB201"
    assert_equal ["IPAN"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "Embraer Ipanema"
    assert_equal ["IPAN"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC3"
    assert_equal ["DC3", "DC3S"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC3S"
    assert_equal ["DC3S"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC8-50"
    assert_equal ["DC85"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC8-40"
    assert_equal ["DC85", "DC86", "DC87", "DC8Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC8 Stage 3"
    assert_equal ["DC8Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC9-10"
    assert_equal ["DC91"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC9-60"
    assert_equal ["DC91", "DC92", "DC93", "DC94", "DC95", "DC9Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC9 Stage 3"
    assert_equal ["DC9Q"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC10-10"
    assert_equal ["DC10"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC4"
    assert_equal ["DC4"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas DC5"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas MD81"
    assert_equal ["MD81"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas MD84"
    assert_equal ["MD81", "MD82", "MD83", "MD87", "MD88"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas MD11"
    assert_equal ["MD11"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas MD90"
    assert_equal ["MD90"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas C133"
    assert_equal ["C133"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "McDonnell Douglas Cargomaster"
    assert_equal ["C133"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC8-100"
    assert_equal ["DH8A"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC8-500"
    assert_equal ["DH8A", "DH8B", "DH8C", "DH8D"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC1"
    assert_equal ["DHC1"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Chipmunk"
    assert_equal ["DHC1"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC2 mk1"
    assert_equal ["DHC2"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC2 mk3"
    assert_equal ["DH2T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Beaver"
    assert_equal ["DHC2"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Turbo Beaver"
    assert_equal ["DH2T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC2"
    assert_equal ["DHC2", "DH2T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC3"
    assert_equal ["DHC3", "DH3T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Otter"
    assert_equal ["DHC3"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Turbo Otter"
    assert_equal ["DH3T"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC4"
    assert_equal ["DHC4"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Caribou"
    assert_equal ["DHC4"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC5"
    assert_equal ["DHC5"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Buffalo"
    assert_equal ["DHC5"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC6"
    assert_equal ["DHC6"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Twin"
    assert_equal ["DHC6"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland DHC7"
    assert_equal ["DHC7"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "de Havilland Dash 7"
    assert_equal ["DHC7"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "aerospatiale atr42"
    assert_equal ["AT43", "AT44", "AT45"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "aerospatiale atr72"
    assert_equal ["AT72"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae 146 100"
    assert_equal ["B461"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae146-400"
    assert_equal ["B461", "B462", "B463"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae jetstream 32"
    assert_equal ["JS32"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae jetstream super 31"
    assert_equal ["JS32"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae jetstream 31"
    assert_equal ["JS31"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae jetstream 41"
    assert_equal ["JS41"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae atp"
    assert_equal ["atp"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bac one-eleven"
    assert_equal ["BA11"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bac111"
    assert_equal ["BA11"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-1000"
    assert_equal ["H25C"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-70"
    assert_equal ["H25B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-75"
    assert_equal ["H25B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-80"
    assert_equal ["H25B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-85"
    assert_equal ["H25B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-90"
    assert_equal ["H25B"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125-95"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "bae bae125"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker 50"
    assert_equal ["F50"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker 61"
    assert_equal ["F60"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker 72"
    assert_equal ["F70"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker 103"
    assert_equal ["F100"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker 80"
    assert_equal [], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker F27"
    assert_equal ["F27"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker Friendship"
    assert_equal ["F27"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker F28"
    assert_equal ["F28"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker Fellowship"
    assert_equal ["F28"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "fokker super"
    assert_equal ["SUNV"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "saab 2000"
    assert_equal ["SB20"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "saab 340"
    assert_equal ["SF34"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "saab 91"
    assert_equal ["SB91"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "saab safir"
    assert_equal ["SB91"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "hawker beechcraft 1900"
    assert_equal ["B190"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna 401"
    assert_equal ["C402"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna 402"
    assert_equal ["C402"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna 208"
    assert_equal ["C208"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna caravan"
    assert_equal ["C208"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna cargomaster"
    assert_equal ["C208"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
  end
  
  def test_003_user_input_matches_icao_codes
    user_input = "cessna grand caravan"
    assert_equal ["C208"], Aircraft.loose_tight_dictionary.find_all(user_input).map(&:icao_code)
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