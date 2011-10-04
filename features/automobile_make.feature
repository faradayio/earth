# Feature: Data import for AutomobileMake
#   As a data user
#   I want to import Make data
#   So that I can perform make-based calculations
# 
#   Scenario: Successfully verifying that fuel efficiency is greater than zero
#     Given a "AutomobileMake" data import fetches results listed in "automobile_make_good"
#     When a data import verifies "Fuel efficiency should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMake" data import fetches results listed in "automobile_make_good"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should be successful
#   
#   Scenario: Failing to verify that fuel efficiency is greater than zero
#     Given a "AutomobileMake" data import fetches results listed in "automobile_make_bad"
#     When a data import verifies "Fuel efficiency should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMake" data import fetches results listed in "automobile_make_bad"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should not be successful
