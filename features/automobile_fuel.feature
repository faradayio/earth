Feature: Data import for AutomobileFuel
  As a data user
  I want to import AutomobileFuel data
  So that I can perform fuel-based calculations

  Scenario: Successfully verifying that base fuel name is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_good"
    When a data import verifies "Base fuel name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that distance key is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_good"
    When a data import verifies "Distance key should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that ef key is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_good"
    When a data import verifies "Ef key should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that blend portion is from 0 to 1 if present
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_good"
    When a data import verifies "Blend portion should be from 0 to 1 if present"
    Then the verification should be successful

  Scenario: Failing to verify that base fuel name is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_bad"
    When a data import verifies "Base fuel name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that distance key is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_bad"
    When a data import verifies "Distance key should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that ef key is never missing
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_bad"
    When a data import verifies "Ef key should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that blend portion is from 0 to 1 if present
    Given a "AutomobileFuel" data import fetches results listed in "automobile_fuel_bad"
    When a data import verifies "Blend portion should be from 0 to 1 if present"
    Then the verification should not be successful
