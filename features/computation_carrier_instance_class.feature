# Feature: Data import for ComputationCarrierInstanceClass
#   As a data user
#   I want to import ComputationCarrierInstanceClass data
#   So that I can perform computation carrier instance class-based calculations
# 
#   Scenario: Successfully verifying that electricity intensity is more than zero
#     Given a "ComputationCarrierInstanceClass" data import fetches results listed in "computation_carrier_instance_class_good"
#     When a data import verifies "Electricity intensity should be more than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity intensity units are kilowatts
#     Given a "ComputationCarrierInstanceClass" data import fetches results listed in "computation_carrier_instance_class_good"
#     When a data import verifies "Electricity intensity units should be kilowatts"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that electricity intensity is more than zero
#     Given a "ComputationCarrierInstanceClass" data import fetches results listed in "computation_carrier_instance_class_bad"
#     When a data import verifies "Electricity intensity should be more than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity intensity units are kilowatts
#     Given a "ComputationCarrierInstanceClass" data import fetches results listed in "computation_carrier_instance_class_bad"
#     When a data import verifies "Electricity intensity units should be kilowatts"
#     Then the verification should not be successful
