Feature: Data import for AutomobileTypeFuelYearControl
  As a data user
  I want to import AutomobileTypeFuelYearControl data
  So that I can perform type fuel year control-based calculations

  Scenario: Successfully verifying that type name, fuel common name, and control name are not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Type name, fuel common name, and control name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that year is from 1990 to 2008
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should be successful

  # Scenario: Successfully verifying that total travel percent for each fuel type year sums to one
  #   Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
  #   When a data import verifies "Total travel percent for each type fuel year should sum to one"
  #   Then the verification should be successful
  # 
  Scenario: Failing to verify that type name, fuel common name, and control name are not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Type name, fuel common name, and control name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is from 1990 to 2008
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should not be successful

  # Scenario: Failing to verify that total travel percent for each fuel type year sums to one
  #   Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
  #   When a data import verifies "Total travel percent for each type fuel year should sum to one"
  #   Then the verification should not be successful
