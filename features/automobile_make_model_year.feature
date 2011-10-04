# Feature: Data import for AutomobileMakeModelYear
#   As a data user
#   I want to import MakeModelYear data
#   So that I can perform model year-based calculations
# 
#   Scenario: Successfully verifying that year is from 1985 to 2011
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_good"
#     When a data import verifies "Year should be from 1985 to 2011"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that fuel efficiences are greater than zero
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_good"
#     When a data import verifies "Fuel efficiencies should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_good"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that year is from 1985 to 2011
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_bad"
#     When a data import verifies "Year should be from 1985 to 2011"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that fuel efficiences are greater than zero
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_bad"
#     When a data import verifies "Fuel efficiencies should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that fuel efficiency units are kilometres per litre
#     Given a "AutomobileMakeModelYear" data import fetches results listed in "automobile_make_model_year_bad"
#     When a data import verifies "Fuel efficiency units should be kilometres per litre"
#     Then the verification should not be successful
