Feature: Data import for AutomobileTypeFuelControl
  As a data user
  I want to import AutomobileTypeFuelControl data
  So that I can perform type fuel control-based calculations

  Scenario: Successfully verifying that type name, fuel common name, and control name are not missing
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_good"
    When a data import verifies "Type name, fuel common name, and control name should never be missing"
    Then the verification should be successful

  Scenario: Successfully verifying that emission factors are greater than zero
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_good"
    When a data import verifies "Emission factors should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that emission factors units are kilograms per kilometre
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_good"
    When a data import verifies "Emission factor units should be kilograms per kilometre"
    Then the verification should be successful

  Scenario: Failing to verify that type name, fuel common name, and control name are not missing
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_bad"
    When a data import verifies "Type name, fuel common name, and control name should never be missing"
    Then the verification should not be successful

  Scenario: Failing to verify that emission factors are greater than zero
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_bad"
    When a data import verifies "Emission factors should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that emission factors units are kilograms per kilometre
    Given a "AutomobileTypeFuelControl" data import fetches results listed in "automobile_type_fuel_control_bad"
    When a data import verifies "Emission factor units should be kilograms per kilometre"
    Then the verification should not be successful
