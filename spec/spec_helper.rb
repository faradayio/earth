require 'rubygems'
require 'bundler'
Bundler.setup
require 'logger'
require 'active_record'
require 'data_miner'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV['EARTH_ENV'] ||= 'test'

require 'earth'

require 'support/integration'
include Integration

Earth.logger.level = Logger::DEBUG

logger = Logger.new 'log/test.log'
ActiveRecord::Base.logger = logger
DataMiner.logger = logger

DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  unless ENV['ALL'] == 'true'
    c.filter_run_excluding :data_miner => true
    c.filter_run_excluding :sanity => true
  end
  c.before :all do
    Earth.init :all, :load_data_miner => true, :skip_parent_associations => :true
  end
  c.before :all, :data_miner => true do
    Earth.run_data_miner!
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
  if ENV['SKIP_FLIGHT_SEGMENT'] == 'true'
    c.filter_run_excluding :flight_segment => true
  end
end
