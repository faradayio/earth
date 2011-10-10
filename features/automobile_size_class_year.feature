Feature: Data import for AutomobileSizeClassYear
  As a data user
  I want to import AutomobileSizeClassYear data
  So that I can perform size class year-based calculations
  
  Scenario: Successfully verifying that year is from 1975 to 2010
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_good"
    When a data import verifies "Year should be from 1975 to 2010"
    Then the verification should be successful
  
  Scenario: Successfully verifying that fuel efficiencies > 0
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_good"
    When a data import verifies "Fuel efficiencies should be greater than zero"
    Then the verification should be successful
  
  Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_good"
    When a data import verifies "Fuel efficiency units should be kilometres per litre"
    Then the verification should be successful
  
  Scenario: Failing to verify that year is from 1975 to 2010
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_bad"
    When a data import verifies "Year should be from 1975 to 2010"
    Then the verification should not be successful
  
  Scenario: Failing to verify that fuel efficiencies > 0
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_bad"
    When a data import verifies "Fuel efficiencies should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Failing to verify that fuel efficiency units are kilometres per litre
    Given a "AutomobileSizeClassYear" data import fetches results listed in "automobile_size_class_year_bad"
    When a data import verifies "Fuel efficiency units should be kilometres per litre"
    Then the verification should not be successful
