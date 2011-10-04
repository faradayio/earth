# Feature: Data import for RailClass
#   As a data user
#   I want to import RailClass data
#   So that I can perform rail class-based calculations
# 
#   Scenario: Successfully verifying that passengers, distance, speed, and electricity intensity are greater than zero
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Passengers, distance, speed, and electricity intensity should be greater than zero"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that distance units are kilometres
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Distance units should be kilometres"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that speed units are kilometres per hour
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Speed units should be kilometres per hour"
#     Then the verification should be successful
#   
#   Scenario: Successfully verifying that electricity intensity units are kilowatt hours per kilometre
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Electricity intensity units should be kilowatt hours per kilometre"
#     Then the verification should be successful
#   
#   Scenario: Successfully verifying that diesel intensity is zero or more
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Diesel intensity should be zero or more"
#     Then the verification should be successful
#   
#   Scenario: Successfully verifying that diesel intensity units are litres per kilometre
#     Given a "RailClass" data import fetches results listed in "rail_class_good"
#     When a data import verifies "Diesel intensity units should be litres per kilometre"
#     Then the verification should be successful
#   
#   Scenario: Failing to verify that passengers, distance, speed, and electricity intensity are greater than zero
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Passengers, distance, speed, and electricity intensity should be greater than zero"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that distance units are kilometres
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Distance units should be kilometres"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that speed units are kilometres per hour
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Speed units should be kilometres per hour"
#     Then the verification should not be successful
#   
#   Scenario: Failing to verify that electricity intensity units are kilowatt hours per kilometre
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Electricity intensity units should be kilowatt hours per kilometre"
#     Then the verification should not be successful
#   
#   Scenario: Failing to verify that diesel intensity is zero or more
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Diesel intensity should be zero or more"
#     Then the verification should not be successful
#   
#   Scenario: Failing to verify that diesel intensity units are litres per kilometre
#     Given a "RailClass" data import fetches results listed in "rail_class_bad"
#     When a data import verifies "Diesel intensity units should be litres per kilometre"
#     Then the verification should not be successful
