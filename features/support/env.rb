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

ActiveRecord::Base.establish_connection(
  'adapter' => 'mysql',
  'database' => 'test_earth',
  'username' => 'root',
  'password' => 'password'
)
ActiveRecord::Base.logger = logger

DataMiner.logger = logger

Earth.init :all, :apply_schemas => true
