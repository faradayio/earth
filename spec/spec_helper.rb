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
  
  # Start by loading any resources that are required in the test,
  # being sure to create any missing tables.
  c.before :all do
    Earth.init :none, :apply_schemas => true
  end
  
  # FULL_MINE=true clears, reloads, and sanity-checks data.
  # Can be very slow because it clears and reloads data for any dependencies.
  if ENV['FULL_MINE'] == 'true'
    c.before :all, :sanity => true do
      # Load data miner steps for all resources
      Earth.init :all, :load_data_miner => true
      
      # Reload the data for the resource being tested, clearing and reloading data
      # for any dependencies along the way
      described_class.run_data_miner!
    end
    
  # FAST_MINE=true clears, reloads, and sanity-checks data for the resource
  # being tested without reloading data for any dependencies. Only works if
  # the test db already has sane data for all the tested resources' dependencies.
  elsif ENV['FAST_MINE'] == 'true'
    c.before :all, :sanity => true do
      # Clear data_miner steps for all loaded resources
      Earth.loaded_resources.each do |resource|
        resource.constantize.data_miner_script.steps.clear
      end
      
      # Load data_miner steps for the resource being tested
      Earth.domains.each do |domain|
        if Earth.resources(domain).include? described_class.name
          require "earth/#{domain}/#{described_class.name.underscore}/data_miner"
        end
      end
      
      # Clear and reload data for the resource being tested
      described_class.create_table!
      described_class.run_data_miner!
    end
  
  # SANITY=true sanity-checks the data currently in the test db
  elsif ENV['SANITY'] != 'true'
    c.filter_run_excluding(:sanity => true)
  end
  
  # SKIP_SLOW=true lets you skip slow tests e.g. FlightSegment
  c.filter_run_excluding(:slow => true) if ENV['SKIP_SLOW'] == 'true'
end
