Feature: Data import for BusClass
  As a data user
  I want to import BusClass data
  So that I can perform bus class-based calculations

  Scenario: Successfully verifying that distance, passengers, speed, and diesel intensity are greater than zero
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Distance, passengers, speed, and diesel intensity should be greater than zero"
    Then the verification should be successful

  Scenario: Successfully verifying that alternative fuels intensity and air conditioning emission factor are zero or more
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Alternative fuels intensity and air conditioning emission factor should be zero or more"
    Then the verification should be successful

  Scenario: Successfully verifying that distance units are kilometres
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Distance units should be kilometres"
    Then the verification should be successful

  Scenario: Successfully verifying that speed units are kilometres per hour
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Speed units should be kilometres per hour"
    Then the verification should be successful

  Scenario: Successfully verifying that diesel intensity and alternative fuels intensity units are litres per kilometre
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Diesel intensity and alternative fuel intensity units should be litres per kilometre"
    Then the verification should be successful

  Scenario: Successfully verifying that air conditioning emission factor units are kilograms per kilometre
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Air conditioning emission factor units should be kilograms per kilometre"
    Then the verification should be successful

  Scenario: Successfully verifying that fallbacks satisfy same criteria as data
    Given a "BusClass" data import fetches results listed in "bus_class_good"
    When a data import verifies "Fallbacks should satisfy same constraints as data"
    Then the verification should be successful

  Scenario: Failing to verify that distance, passengers, speed, and diesel intensity are greater than zero
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Distance, passengers, speed, and diesel intensity should be greater than zero"
    Then the verification should not be successful

  Scenario: Failing to verify that alternative fuels intensity and air conditioning emission factor are zero or more
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Alternative fuels intensity and air conditioning emission factor should be zero or more"
    Then the verification should not be successful

  Scenario: Failing to verify that distance units are kilometres
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Distance units should be kilometres"
    Then the verification should not be successful

  Scenario: Failing to verify that speed units are kilometres per hour
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Speed units should be kilometres per hour"
    Then the verification should not be successful

  Scenario: Failing to verify that diesel intensity and alternative fuels intensity units are litres per kilometre
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Diesel intensity and alternative fuel intensity units should be litres per kilometre"
    Then the verification should not be successful

  Scenario: Failing to verify that air conditioning emission factor units are kilograms per kilometre
    Given a "BusClass" data import fetches results listed in "bus_class_bad"
    When a data import verifies "Air conditioning emission factor units should be kilograms per kilometre"
    Then the verification should not be successful
