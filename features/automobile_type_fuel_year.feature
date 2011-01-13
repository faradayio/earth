Feature: Data import for AutomobileTypeFuelYear
  As a data user
  I want to import AutomobileTypeFuelYear data
  So that I can perform type fuel year-based calculations

  Scenario: Successfully verifying that type name and fuel common name are not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Type name and fuel common name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that year is between 1990 and 2008
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Year should be between 1990 and 2008"
    Then the verification should be successful

  Scenario: Successfully verifying that total travel, fuel consumption, and emission factors are greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Total travel, fuel consumption, and emission factors should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that units are correct
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Units should be correct"
    Then the verification should be successful

  Scenario: Failing to verify that type name and fuel common name are not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Type name and fuel common name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is between 1990 and 2008
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Year should be between 1990 and 2008"
    Then the verification should not be successful

  Scenario: Failing to verify that total travel, fuel consumption, and emission factors are greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Total travel, fuel consumption, and emission factors should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that units are correct
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Units should be correct"
    Then the verification should not be successful
