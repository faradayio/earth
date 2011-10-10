Feature: Data import for ComputationCarrier
  As a data user
  I want to import ComputationCarrier data
  So that I can perform computation carrier-based calculations

  Scenario: Successfully verifying that power usage effectiveness >= 1.0
    Given a "ComputationCarrier" data import fetches results listed in "computation_carrier_good"
    When a data import verifies "Power usage effectiveness should be one or more"
    Then the verification should be successful

  Scenario: Failing to verify that power usage effectiveness >= 1.0
    Given a "ComputationCarrier" data import fetches results listed in "computation_carrier_bad"
    When a data import verifies "Power usage effectiveness should be one or more"
    Then the verification should not be successful
