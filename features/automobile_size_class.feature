Feature: Data import for AutomobileSizeClass
  As a data user
  I want to import AutomobileSizeClass data
  So that I can perform size class-based calculations

  Scenario: Successfully verifying that annual distance > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Annual distance should be greater than zero"
    Then the verification should be successful
  
  Scenario: Successfully verifying that annual distance units are kilometres
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Annual distance units should be kilometres"
    Then the verification should be successful
  
  Scenario: Successfully verifying that fuel efficiencies > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Fuel efficiencies should be greater than zero"
    Then the verification should be successful
  
  Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Fuel efficiency units should be kilometres per litre"
    Then the verification should be successful
  
  Scenario: Successfully verifying that any fuel efficiency multipliers > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Any fuel efficiency multipliers should be greater than zero"
    Then the verification should be successful
  
  Scenario: Successfully verifying that fallback fuel efficiency multipliers > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_good"
    When a data import verifies "Fallback fuel efficiency multipliers should be greater than zero"
    Then the verification should be successful

  Scenario: Failing to verify that annual distance > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_bad"
    When a data import verifies "Annual distance should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Failing to verify that annual distance units are kilometres
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_bad"
    When a data import verifies "Annual distance units should be kilometres"
    Then the verification should not be successful
  
  Scenario: Failing to verify that fuel efficiencies > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_bad"
    When a data import verifies "Fuel efficiencies should be greater than zero"
    Then the verification should not be successful
  
  Scenario: Failing to verify that fuel efficiency units are kilometres per litre
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_bad"
    When a data import verifies "Fuel efficiency units should be kilometres per litre"
    Then the verification should not be successful
  
  Scenario: Failing to verify that any fuel efficiency multipliers > 0
    Given a "AutomobileSizeClass" data import fetches results listed in "automobile_size_class_bad"
    When a data import verifies "Any fuel efficiency multipliers should be greater than zero"
    Then the verification should not be successful
