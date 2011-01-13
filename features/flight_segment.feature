Feature: Data import for FlightSegment
  As a data user
  I want to import FlightSegment data
  So that I can look up T-100 flight segment data
  
  Scenario: Successfully verifying that FlightSegments have related Aircraft
    Given a "FlightSegment" data import fetches results listed in "flight_segment_good"
    When a data import verifies "All segments have an associated aircraft"
    Then the verification should be successful

  Scenario: Failing to verify that FlightSegments have related Aircraft
    Given a "FlightSegment" data import fetches results listed in "flight_segment_bad"
    When a data import verifies "All segments have an associated aircraft"
    Then the verification should not be successful
