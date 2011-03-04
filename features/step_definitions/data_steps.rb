require 'active_record'
require 'active_record/fixtures'

Given /^a "([^\"]*)" data import fetches results listed in "(.*)"$/ do |model, file_name|
  @data_import_model = model.constantize
  table_name = @data_import_model.table_name

  fixture_path = File.expand_path("features/support/imports/#{file_name}", Dir.pwd) 

  fixture = Fixtures.new @data_import_model.connection, table_name, model, fixture_path

  @data_import_model.connection.transaction(:requires_new => true) do
    fixture.delete_existing_fixtures
    fixture.insert_fixtures
  end
end

When /^a data import verifies "(.*)"$/ do |verification_step_name|
  @verification = @data_import_model.data_miner_config.steps.find { |f|
    f.respond_to?(:description) and f.description == verification_step_name
  }
  @verification_result = begin
                           @verification.run
                           true
                         rescue => e
                           false
                         end
end

Then /^the verification should be successful$/ do
  @verification_result.should be_true
end
Then /^the verification should not be successful$/ do
  @verification_result.should be_false
end
