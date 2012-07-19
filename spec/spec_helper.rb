require 'rubygems'
require 'bundler'
Bundler.setup
require 'logger'
require 'active_record'
require 'data_miner'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'earth'

require 'support/integration'
include Integration

Earth.logger.level = Logger::DEBUG

ActiveRecord::Base.logger = logger
DataMiner.logger = logger

DataMiner::Run.auto_upgrade!
DataMiner.unit_converter = :conversions

RSpec.configure do |c|
  unless ENV['ALL'] == 'true'
    c.filter_run_excluding :data_miner => true
  end
end
