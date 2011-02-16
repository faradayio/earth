Feature: Data import for AutomobileTypeFuelYearControl
  As a data user
  I want to import AutomobileTypeFuelYearControl data
  So that I can perform type fuel year control-based calculations

  Scenario: Successfully verifying that type name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Type name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that fuel common name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Fuel common name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that type fuel control name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Type fuel control name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that type fuel year name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Type fuel year name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that control name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_good"
    When a data import verifies "Control name should never be missing"
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
  Scenario: Failing to verify that type name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Type name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that fuel common name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Fuel common name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that type fuel control name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Type fuel control name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that type fuel year name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Type fuel year name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that control name is not missing
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Control name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is from 1990 to 2008
    Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should not be successful

  # Scenario: Failing to verify that total travel percent for each fuel type year sums to one
  #   Given a "AutomobileTypeFuelYearControl" data import fetches results listed in "automobile_type_fuel_year_control_bad"
  #   When a data import verifies "Total travel percent for each type fuel year should sum to one"
  #   Then the verification should not be successful
