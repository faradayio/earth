# Feature: Data import for EgridSubregion
#   As a data user
#   I want to import EgridSubregion data
#   So that I can perform eGRID subregion-based calculations
# 
#   Scenario: Successfully verifying that egrid region name is never missing
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Egrid region name should never be missing"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that net generation is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Net generation should be > 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity co2 emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity co2 emission factor should be > 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity ch4 emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity ch4 emission factor should be > 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity n2o emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity n2o emission factor should be > 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity emission factor should be > 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity co2 biogenic emission factor is 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity co2 biogenic emission factor should be 0"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that net generation units are megawatt hours
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Net generation units should be megawatt hours"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity co2 emission factor units are kilograms per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity co2 emission factor units should be kilograms per kilowatt hour"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity co2 biogenic emission factor units are kilograms per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity co2 biogenic emission factor units should be kilograms per kilowatt hour"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity ch4 emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity ch4 emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity n2o emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity n2o emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should be successful
# 
#   Scenario: Successfully verifying that electricity emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_good"
#     When a data import verifies "Electricity emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should be successful
# 
#   Scenario: Failing to verify that egrid region name is never missing
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Egrid region name should never be missing"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that net generation is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Net generation should be > 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity co2 emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity co2 emission factor should be > 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity ch4 emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity ch4 emission factor should be > 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity n2o emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity n2o emission factor should be > 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity emission factor is > 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity emission factor should be > 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity co2 biogenic emission factor is 0
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity co2 biogenic emission factor should be 0"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that net generation units are megawatt hours
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Net generation units should be megawatt hours"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity co2 emission factor units are kilograms per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity co2 emission factor units should be kilograms per kilowatt hour"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity co2 biogenic emission factor units are kilograms per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity co2 biogenic emission factor units should be kilograms per kilowatt hour"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity ch4 emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity ch4 emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity n2o emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity n2o emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should not be successful
# 
#   Scenario: Failing to verify that electricity emission factor units are kilograms co2e per kilowatt hour
#     Given a "EgridSubregion" data import fetches results listed in "egrid_subregion_bad"
#     When a data import verifies "Electricity emission factor units should be kilograms co2e per kilowatt hour"
#     Then the verification should not be successful
