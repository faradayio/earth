Feature: Data import for FuelYear
  As a data user
  I want to import FuelYear data
  So that I can perform fuel year control-based calculations

  Scenario: Successfully verifying that fuel name is never missing
    Given a "FuelYear" data import fetches results listed in "fuel_year_good"
    When a data import verifies "Fuel name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that year is from 1990 to 2008
    Given a "FuelYear" data import fetches results listed in "fuel_year_good"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should be successful

  Scenario: Successfully verifying that carbon content and energy content are greater than zero
    Given a "FuelYear" data import fetches results listed in "fuel_year_good"
    When a data import verifies "Carbon content and energy content should be greater than zero"
    Then the verification should be successful

  # Scenario: Successfully verifying that units are correct
  #   Given a "FuelYear" data import fetches results listed in "fuel_year_good"
  #   When a data import verifies "Units should be correct"
  #   Then the verification should be successful
  # 
  Scenario: Failing to verify that fuel name is never missing
    Given a "FuelYear" data import fetches results listed in "fuel_year_bad"
    When a data import verifies "Fuel name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is from 1990 to 2008
    Given a "FuelYear" data import fetches results listed in "fuel_year_bad"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should not be successful

  Scenario: Failing to verify that carbon content and energy content are greater than zero
    Given a "FuelYear" data import fetches results listed in "fuel_year_bad"
    When a data import verifies "Carbon content and energy content should be greater than zero"
    Then the verification should not be successful

  # Scenario: Failing to verify that units are correct
  #   Given a "FuelYear" data import fetches results listed in "fuel_year_bad"
  #   When a data import verifies "Units should be correct"
  #   Then the verification should not be successful
