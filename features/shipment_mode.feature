# Feature: Data import for ShipmentMode
#   As a data user
#   I want to import ShipmentMode data
#   So that I can perform shipment mode-based calculations
# 
#   Scenario: Successfully verifying that route inefficiency factor >= 1
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_good"
#     When a data import verifies "Route inefficiency factor should be one or more"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that route inefficiency factor >= 1
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_bad"
#     When a data import verifies "Route inefficiency factor should be one or more"
#     Then the verification should not be successful
# 
#   Scenario: Successfully verifying that transport emission factor > 0
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_good"
#     When a data import verifies "Transport emission factor should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that transport emission factor > 0
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_bad"
#     When a data import verifies "Transport emission factor should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Successfully verifying that transport emission factor units is never missing
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_good"
#     When a data import verifies "Transport emission factor units should never be missing"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that transport emission factor units is never missing
#     Given a "ShipmentMode" data import fetches results listed in "shipment_mode_bad"
#     When a data import verifies "Transport emission factor units should never be missing"
#     Then the verification should not be successful
