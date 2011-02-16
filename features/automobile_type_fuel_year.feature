Feature: Data import for AutomobileTypeFuelYear
  As a data user
  I want to import AutomobileTypeFuelYear data
  So that I can perform type fuel year-based calculations

  Scenario: Successfully verifying that type name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Type name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that fuel common name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Fuel common name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that type year name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Type year name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that year is from 1990 to 2008
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should be successful

  Scenario: Successfully verifying that total travel is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Total travel should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that fuel consumption is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Fuel consumption should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that ch4 emission factor is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Ch4 emission factor should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that n2o emission factor is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "N2o emission factor should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that total travel units are kilometres
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Total travel units should be kilometres"
    Then the verification should be successful

  Scenario: Successfully verifying that fuel consumption units are litres
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Fuel consumption units should be litres"
    Then the verification should be successful

  Scenario: Successfully verifying that ch4 emission factor units are kilograms per litre
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "Ch4 emission factor units should be kilograms per litre"
    Then the verification should be successful

  Scenario: Successfully verifying that n2o emission factor units are kilograms per litre
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_good"
    When a data import verifies "N2o emission factor units should be kilograms per litre"
    Then the verification should be successful

  Scenario: Failing to verify that type name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Type name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that fuel common name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Fuel common name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that type year name is not missing
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Type year name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is from 1990 to 2008
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should not be successful

  Scenario: Failing to verify that total travel is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Total travel should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that fuel consumption is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Fuel consumption should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that ch4 emission factor is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Ch4 emission factor should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that n2o emission factor is greater than zero
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "N2o emission factor should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that total travel units are kilometres
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Total travel units should be kilometres"
    Then the verification should not be successful

  Scenario: Failing to verify that fuel consumption units are litres
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Fuel consumption units should be litres"
    Then the verification should not be successful

  Scenario: Failing to verify that ch4 emission factor units are kilograms per litre
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "Ch4 emission factor units should be kilograms per litre"
    Then the verification should not be successful

  Scenario: Failing to verify that n2o emission factor units are kilograms per litre
    Given a "AutomobileTypeFuelYear" data import fetches results listed in "automobile_type_fuel_year_bad"
    When a data import verifies "N2o emission factor units should be kilograms per litre"
    Then the verification should not be successful
