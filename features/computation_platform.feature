Feature: Data import for ComputationPlatform
  As a data user
  I want to import ComputationPlatform data
  So that I can perform computation platform-based calculations

  Scenario: Successfully verifying that data center company name is never missing
    Given a "ComputationPlatform" data import fetches results listed in "computation_platform_good"
    When a data import verifies "Data center company name should never be missing"
    Then the verification should be successful

  Scenario: Failing to verify that data center company name is never missing
    Given a "ComputationPlatform" data import fetches results listed in "computation_platform_bad"
    When a data import verifies "Data center company name should never be missing"
    Then the verification should not be successful
