Feature: Data import for Carrier
  As a data user
  I want to import Carrier data
  So that I can do carrier-based calculations

  Scenario: Successfully verifying that all entries have corporate_emission_factor >= 0 
    Given a "Carrier" data import fetches results listed in "carrier_good"
    When a data import verifies "All entries should have corporate_emission_factor >= 0"
    Then the verification should be successful

  Scenario: Failing to verify that all entries have corporate_emission_factor >= 0 
    Given a "Carrier" data import fetches results listed in "carrier_bad"
    When a data import verifies "All entries should have corporate_emission_factor >= 0"
    Then the verification should not be successful
