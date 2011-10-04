# Feature: Data import for AutomobileMakeFleetYear
#   As a data user
#   I want to import MakeFleetYear data
#   So that I can perform year-based calculations
#   
#   Scenario: Successfully verifying that year is from 1978 to 2010
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_good"
#     When a data import verifies "Year should be from 1978 to 2010"
#     Then the verification should be successful
#   
#   Scenario: Successfully verifying that fuel efficiency and volume are greater than zero
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_good"
#     When a data import verifies "Fuel efficiency and volume should be greater than zero"
#     Then the verification should be successful
#   
#   Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_good"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should be successful
#   
#   Scenario: Failing to verify that year is from 1978 to 2010
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_bad"
#     When a data import verifies "Year should be from 1978 to 2010"
#     Then the verification should not be successful
#   
#   Scenario: Failing to verify that fuel efficiency and volume are greater than zero
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_bad"
#     When a data import verifies "Fuel efficiency and volume should be greater than zero"
#     Then the verification should not be successful
#   
#   Scenario: Failing to verify that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeFleetYear" data import fetches results listed in "automobile_make_fleet_year_bad"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should not be successful
