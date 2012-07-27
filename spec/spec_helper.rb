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

ActiveRecord::Base.logger = DataMiner.logger = Logger.new('log/test.log')

DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  c.filter_run_excluding(:data_miner => true) unless ENV['MINE'] == 'true'
  c.filter_run_excluding(:sanity => true) unless ENV['SANITY'] == 'true'
  c.filter_run_excluding(:flight_segment => true) if ENV['SKIP_FLIGHT_SEGMENT'] == 'true'
  c.before :all do
    Earth.init :all, :load_data_miner => true, :skip_parent_associations => :true
  end
  
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

Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |path| require path }
