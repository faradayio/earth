require 'rubygems'
require 'bundler'
Bundler.setup
require 'logger'
require 'active_record'
require 'data_miner'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'earth'

logger = Logger.new $stderr
logger.level = Logger::DEBUG

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

ActiveRecord::Base.logger = logger

DataMiner.logger = logger

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end
