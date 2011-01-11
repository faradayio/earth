Feature: Data import for ServerType
  As a data user
  I want to import ServerType data
  So that I can perform server type-based calculations

  Scenario: Successfully verifying that data center company name is never missing
    Given a "ServerType" data import fetches results listed in "server_type_good"
    When a data import verifies "Data center company name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that electricity draw is more than zero
    Given a "ServerType" data import fetches results listed in "server_type_good"
    When a data import verifies "Electricity draw should be more than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that electricity draw units are kilowatts
    Given a "ServerType" data import fetches results listed in "server_type_good"
    When a data import verifies "Electricity draw units should be kilowatts"
    Then the verification should be successful

  Scenario: Failing to verify that data center company name is never missing
    Given a "ServerType" data import fetches results listed in "server_type_bad"
    When a data import verifies "Data center company name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that electricity draw is more than zero
    Given a "ServerType" data import fetches results listed in "server_type_bad"
    When a data import verifies "Electricity draw should be more than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that electricity draw units are kilowatts
    Given a "ServerType" data import fetches results listed in "server_type_bad"
    When a data import verifies "Electricity draw units should be kilowatts"
    Then the verification should not be successful
