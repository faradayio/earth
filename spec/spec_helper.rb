require 'bundler/setup'

require 'active_record'
require 'data_miner'

require 'factory_girl'

ENV['EARTH_ENV'] ||= 'test'

require 'support/integration'
include Integration

require 'logger'
ActiveRecord::Base.logger = DataMiner.logger = Logger.new('log/test.log')

require 'earth'
Earth.init :connect => true, :mine_original_sources => true
DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  # Remember and revert any data added or removed by tests
  # (doesn't apply to data loaded with FULL_MINE=true or FAST_MINE=true)
  c.before :each do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.transaction_joinable = false
    ActiveRecord::Base.connection.begin_db_transaction
  end
  c.after :each do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end
  
  # FULL_MINE=true clears, reloads, and sanity-checks data. This can be
  # very slow because it clears and reloads data for any dependencies.
  if ENV['FULL_MINE'] == 'true'
    c.before :all, :sanity => true do
      described_class.run_data_miner!
    end
  
  # FAST_MINE=true clears, reloads, and sanity-checks data without
  # reloading data for any dependencies. Only works if the test db
  # already has sane data for all the tested resources' dependencies.
  elsif ENV['FAST_MINE'] == 'true'
    c.before :all, :sanity => true do
      # Clear data_miner steps for all resources except the resource
      # being tested
      Earth.resource_models.each do |resource_model|
        resource_model.data_miner_script.steps.clear unless resource_model == described_class
      end
      
      # Clear and reload data for the resource being tested
      described_class.run_data_miner!
    end
  
  # SANITY=true sanity-checks the data currently in the test db
  elsif ENV['SANITY'] != 'true'
    c.filter_run_excluding(:sanity => true)
  end
  
  # SKIP_SLOW=true lets you skip slow tests e.g. FlightSegment
  c.filter_run_excluding(:slow => true) if ENV['SKIP_SLOW'] == 'true'
end
