Feature: Data import for ServerTypeAlias
  As a data user
  I want to import ServerTypeAlias data
  So that I can perform server type alias-based calculations

  Scenario: Successfully verifying that server type name and platform name are never missing
    Given a "ServerTypeAlias" data import fetches results listed in "server_type_alias_good"
    When a data import verifies "Server type name and platform name should never be missing"
    Then the verification should be successful

  Scenario: Failing to verify that server type name and platform name are never missing
    Given a "ServerTypeAlias" data import fetches results listed in "server_type_alias_bad"
    When a data import verifies "Server type name and platform name should never be missing"
    Then the verification should not be successful
