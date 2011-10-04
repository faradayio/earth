# Feature: Data import for AutomobileTypeFuelYearAge
#   As a data user
#   I want to import AutomobileTypeFuelYearAge data
#   So that I can perform type fuel year age-based calculations
# 
#   Scenario: Successfully verifying that type name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Type name should never be missing"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that fuel common name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Fuel common name should never be missing"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that type fuel year name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Type fuel year name should never be missing"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that year is 2008
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Year should be 2008"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that age is from zero to thirty
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Age should be from 0 to 30"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that total travel percent is from zero to one
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Total travel percent should be from 0 to 1"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that annual distance is greater than zero
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Annual distance should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that vehicles is greater than zero
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Vehicles should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that annual distance units are kilometres
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_good"
#     When a data import verifies "Annual distance units should be kilometres"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that type name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Type name should never be missing"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that fuel common name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Fuel common name should never be missing"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that type fuel year name is not missing
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Type fuel year name should never be missing"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that year is 2008
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Year should be 2008"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that age is from zero to thirty
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Age should be from 0 to 30"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that total travel percent is from zero to one
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Total travel percent should be from 0 to 1"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that annual distance is greater than zero
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Annual distance should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that vehicles is greater than zero
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Vehicles should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that annual distance units are kilometres
#     Given a "AutomobileTypeFuelYearAge" data import fetches results listed in "automobile_type_fuel_year_age_bad"
#     When a data import verifies "Annual distance units should be kilometres"
#     Then the verification should not be successful
