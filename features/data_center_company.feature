Feature: Data import for DataCenterCompany
  As a data user
  I want to import DataCenterCompany data
  So that I can perform data center company-based calculations

  Scenario: Successfully verifying that power usage effectiveness >= 1.0
    Given a "DataCenterCompany" data import fetches results listed in "data_center_company_good"
    When a data import verifies "Power usage effectiveness should be one or more"
    Then the verification should be successful

  Scenario: Failing to verify that power usage effectiveness >= 1.0
    Given a "DataCenterCompany" data import fetches results listed in "data_center_company_bad"
    When a data import verifies "Power usage effectiveness should be one or more"
    Then the verification should not be successful
