require 'bundler/setup'

require 'active_record'
require 'data_miner'

require 'factory_girl'

ENV['EARTH_ENV'] ||= 'test'

require 'support/integration'
include Integration

require 'logger'
logger = Logger.new 'log/test.log'
ActiveRecord::Base.logger = logger
DataMiner.logger = logger

DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  unless ENV['ALL'] == 'true'
    c.filter_run_excluding :sanity => true
  end
  if ENV['SKIP_FLIGHT_SEGMENT'] == 'true'
    c.filter_run_excluding :flight_segment => true
  end

  c.before :all do
    require 'earth'
    Earth.init :mine_original_sources => true, :connect => true
  end
  c.before :all, :sanity => true do
    described_class.run_data_miner!
  end

  c.before(:each) do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.transaction_joinable = false
    ActiveRecord::Base.connection.begin_db_transaction
  end
  c.after(:each) do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end
end
