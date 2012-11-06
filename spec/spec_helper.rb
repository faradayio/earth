require 'bundler/setup'

require 'active_record'
require 'data_miner'

require 'factory_girl'

ENV['EARTH_ENV'] ||= 'test'
ENV['DATABASE_URL'] ||= 'mysql2://root:password@localhost/test_earth'

require 'support/integration'
include Integration

require 'logger'
ActiveRecord::Base.logger = DataMiner.logger = Logger.new('log/test.log')

require 'earth'
Earth.init :connect => true, :mine_original_sources => true
DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  c.before :all do
    # FULL_MINE=true clears, reloads, and sanity-checks data for the
    # tested resource. This can be very slow because it clears and reloads
    # data for any dependencies.
    if ENV['FULL_MINE'] == 'true'
      described_class.run_data_miner!
    
    # FAST_MINE=true clears, reloads, and sanity-checks data for the
    # tested resource without reloading data for any dependencies. Only
    # works if the test db already has sane data for those dependencies.
    elsif ENV['FAST_MINE'] == 'true'
      Earth.resource_models.each do |resource_model|
        resource_model.data_miner_script.steps.clear unless resource_model == described_class
      end
      described_class.run_data_miner!
    else
      Earth.resource_models.each do |resource_model|
        resource_model.create_table! false
      end
    end
  end
  
  # SANITY=true sanity-checks data for the tested resource
  c.filter_run_excluding(:sanity => true) unless (ENV['SANITY'] == 'true' || ENV['FAST_MINE'] == 'true' || ENV['FULL_MINE'] == 'true')
  
  # SKIP_SLOW=true lets you skip slow tests e.g. FlightSegment
  c.filter_run_excluding(:slow => true) if ENV['SKIP_SLOW'] == 'true'
  
  # TEST_MINING=true runs spec/data_mining_spec.rb which data_mines all resources
  c.filter_run_excluding :mine_all => true unless ENV['TEST_MINING'] == 'true'
  
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
end
