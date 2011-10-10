Feature: Data import for CarrierMode
  As a data user
  I want to import CarrierMode data
  So that I can perform carrier mode-based calculations
  
  Scenario: Successfully verifying that carrier name is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Carrier name should never be missing"
    Then the verification should be successful
  
  Scenario: Failing to verify that carrier name is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Carrier name should never be missing"
    Then the verification should not be successful
  
  Scenario: Successfully verifying that mode name is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Mode name should never be missing"
    Then the verification should be successful
  
  Scenario: Failing to verify that mode name is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Mode name should never be missing"
    Then the verification should not be successful
  
  Scenario: Successfully verifying that transport emission factor units is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Transport emission factor units should never be missing"
    Then the verification should be successful
  
  Scenario: Failing to verify that transport emission factor units is never missing
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Transport emission factor units should never be missing"
    Then the verification should not be successful
  
  Scenario: Successfully verifying that package volume > 0
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Package volume should be greater than zero"
    Then the verification should be successful
  
  Scenario: Failing to verify that package volume > 0
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Package volume should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Successfully verifying that transport emission factor > 0
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Transport emission factor should be greater than zero"
    Then the verification should be successful
  
  Scenario: Failing to verify that transport emission factor > 0
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Transport emission factor should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Successfully verifying that route inefficiency factor >= 1
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_good"
    When a data import verifies "Route inefficiency factor should be one or more"
    Then the verification should be successful
  
  Scenario: Failing to verify that route inefficiency factor >= 1
    Given a "CarrierMode" data import fetches results listed in "carrier_mode_bad"
    When a data import verifies "Route inefficiency factor should be one or more"
    Then the verification should not be successful
