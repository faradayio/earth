Feature: Data import for GreenhouseGas
  As a data user
  I want to import GreenhouseGas data
  So that I can perform global warming potential-based calculations

  Scenario: Successfully verifying that abbreviation and IPCC report are never missing
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_good"
    When a data import verifies "Abbreviation and IPCC report should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that time horizon is 100
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_good"
    When a data import verifies "Time horizon should be 100"
    Then the verification should be successful

  Scenario: Successfully verifying that time horizon units are years
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_good"
    When a data import verifies "Time horizon units should be years"
    Then the verification should be successful

  Scenario: Successfully verifying that global warming potential is one or more
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_good"
    When a data import verifies "Global warming potential should be one or more"
    Then the verification should be successful

  Scenario: Failing to verify that abbreviation and IPCC report are never missing
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_bad"
    When a data import verifies "Abbreviation and IPCC report should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that time horizon is 100
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_bad"
    When a data import verifies "Time horizon should be 100"
    Then the verification should not be successful

  Scenario: Failing to verify that time horizon units are years
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_bad"
    When a data import verifies "Time horizon units should be years"
    Then the verification should not be successful

  Scenario: Failing to verify that global warming potential is one or more
    Given a "GreenhouseGas" data import fetches results listed in "greenhouse_gas_bad"
    When a data import verifies "Global warming potential should be one or more"
    Then the verification should not be successful
