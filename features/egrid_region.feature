# Feature: Data import for EgridRegion
#   As a data user
#   I want to import EgridRegion data
#   So that I can perform eGRID region-based calculations
# 
#   Scenario: Successfully verifying that loss factor is greater than zero and less than one
#     Given a "EgridRegion" data import fetches results listed in "egrid_region_good"
#     When a data import verifies "Loss factor should be greater than zero and less than one"
#     Then the verification should be successful
# 
#   # FIXME TODO get this to work
#   # Scenario: Successfully verifying that fallback loss factor is greater than zero and less than one
#   #   Given a "EgridRegion" data import fetches results listed in "egrid_region_good"
#   #   When a data import verifies "Fallback loss factor should be greater than zero and less than one"
#   #   Then the verification should be successful
# 
#   Scenario: Failing to verify that loss factor is greater than zero and less than one
#     Given a "EgridRegion" data import fetches results listed in "egrid_region_bad"
#     When a data import verifies "Loss factor should be greater than zero and less than one"
#     Then the verification should not be successful
