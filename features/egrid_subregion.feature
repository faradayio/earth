Feature: Data import for EgridSubregion
  As a data user
  I want to import EgridSubregion data
  So that I can perform eGRID subregion-based calculations

  # FIXME TODO
  # Scenario: Successfully verifying that eGRID region name appears in egrid_regions
  #   Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
  #   When a data import verifies "eGRID region name should appear in egrid_regions"
  #   Then the verification should be successful

  Scenario: Successfully verifying that electricity emission factor is greater than zero
    Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
    When a data import verifies "Electricity emission factor should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that electricity emission factor units are kilograms per kilowatt hour
    Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
    When a data import verifies "Electricity emission factor units should be kilograms per kilowatt hour"
    Then the verification should be successful

  # FIXME TODO
  # Scenario: Failing to verify that eGRID region name appears in egrid_regions
  #   Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
  #   When a data import verifies "eGRID region name should appear in egrid_regions"
  #   Then the verification should not be successful

  Scenario: Failing to verify that electricity emission factor is greater than zero
    Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
    When a data import verifies "Electricity emission factor should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that electricity emission factor units are kilograms per kilowatt hour
    Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
    When a data import verifies "Electricity emission factor units should be kilograms per kilowatt hour"
    Then the verification should not be successful