Feature: Data import for AutomobileTypeFuelAge
  As a data user
  I want to import AutomobileTypeFuelAge data
  So that I can perform type fuel age-based calculations
  
  Scenario: Successfully verifying that type name and fuel common name are not missing
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_good"
    When a data import verifies "Type name and fuel common name should never be missing"
    Then the verification should be successful
  
  Scenario: Successfully verifying that age is from zero to thirty
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_good"
    When a data import verifies "Age should be from zero to thirty"
    Then the verification should be successful
  
  Scenario: Successfully verifying that age percent and total travel percent are from zero to one
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_good"
    When a data import verifies "Age percent and total travel percent should be from zero to one"
    Then the verification should be successful
  
  Scenario: Successfully verifying that age annual distance and vehicles are greater than zero
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_good"
    When a data import verifies "Annual distance and vehicles should be greater than zero"
    Then the verification should be successful
  
  Scenario: Successfully verifying that annual distance units are kilometres
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_good"
    When a data import verifies "Annual distance units should be kilometres"
    Then the verification should be successful
  
  Scenario: Failing to verify that type name and fuel common name are not missing
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_bad"
    When a data import verifies "Type name and fuel common name should never be missing"
    Then the verification should not be successful
  
  Scenario: Failing to verify that age is from zero to thirty
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_bad"
    When a data import verifies "Age should be from zero to thirty"
    Then the verification should not be successful
  
  Scenario: Failing to verify that age percent and total travel percent are from zero to one
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_bad"
    When a data import verifies "Age percent and total travel percent should be from zero to one"
    Then the verification should not be successful
  
  Scenario: Failing to verify that annual distance and vehicles are greater than zero
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_bad"
    When a data import verifies "Annual distance and vehicles should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Failing to verify that annual distance units are kilometres
    Given a "AutomobileTypeFuelAge" data import fetches results listed in "automobile_type_fuel_age_bad"
    When a data import verifies "Annual distance units should be kilometres"
    Then the verification should not be successful
