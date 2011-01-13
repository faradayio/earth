Feature: Data import for AutomobileTypeYear
  As a data user
  I want to import AutomobileTypeYear data
  So that I can perform type fuel year control-based calculations

  Scenario: Successfully verifying that type name is never missing
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_good"
    When a data import verifies "Type name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that year is from 1990 to 2008
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_good"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should be successful

  Scenario: Successfully verifying that HFC emissions are zero or more
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_good"
    When a data import verifies "HFC emissions should be zero or more"
    Then the verification should be successful

  Scenario: Successfully verifying that HFC emissions units are kilograms CO2e
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_good"
    When a data import verifies "HFC emissions units should be kilograms CO2e"
    Then the verification should be successful

  Scenario: Failing to verify that type name is never missing
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_bad"
    When a data import verifies "Type name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that year is from 1990 to 2008
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_bad"
    When a data import verifies "Year should be from 1990 to 2008"
    Then the verification should not be successful

  Scenario: Failing to verify that HFC emissions are zero or more
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_bad"
    When a data import verifies "HFC emissions should be zero or more"
    Then the verification should not be successful

  Scenario: Failing to verify that HFC emissions units are kilograms CO2e
    Given a "AutomobileTypeYear" data import fetches results listed in "automobile_type_year_bad"
    When a data import verifies "HFC emissions units should be kilograms CO2e"
    Then the verification should not be successful
