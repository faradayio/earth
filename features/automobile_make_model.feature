# Feature: Data import for AutomobileMakeModel
#   As a data user
#   I want to import MakeModel data
#   So that I can perform model-based calculations
# 
#   Scenario: Successfully verifying that fuel efficiences are greater than zero
#     Given a "AutomobileMakeModel" data import fetches results listed in "automobile_make_model_good"
#     When a data import verifies "Fuel efficiencies should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeModel" data import fetches results listed in "automobile_make_model_good"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that fuel efficiences are greater than zero
#     Given a "AutomobileMakeModel" data import fetches results listed in "automobile_make_model_bad"
#     When a data import verifies "Fuel efficiencies should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeModel" data import fetches results listed in "automobile_make_model_bad"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should not be successful
