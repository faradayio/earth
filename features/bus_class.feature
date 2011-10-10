Feature: Data import for BusClass
  As a data user
  I want to import BusClass data
  So that I can perform bus class-based calculations

  Scenario: Successfully verifying that some attributes are greater than zero
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Some attributes should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that some attributes are zero or more
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Some attributes should be zero or more"
    Then the verification should be successful

  Scenario: Successfully verifying that distance units are correct
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Units should be correct"
    Then the verification should be successful

  Scenario: Successfully verifying that fallbacks satisfy same criteria as data
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Fallbacks should satisfy same constraints as data"
    Then the verification should be successful

  Scenario: Failing to verify that some attributes are greater than zero
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Some attributes should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that some attributes are zero or more
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Some attributes should be zero or more"
    Then the verification should not be successful

  Scenario: Failing to verify that distance units are correct
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Units should be correct"
    Then the verification should not be successful
