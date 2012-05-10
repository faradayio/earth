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

case ENV['EARTH_DB_ADAPTER']
when 'mysql'
  adapter = 'mysql2'
  database = 'test_earth'
  username = 'root'
  password = 'password'
  
  # system %{mysql -u #{username} -p#{password} -e "DROP DATABASE #{database}"}
  # system %{mysql -u #{username} -p#{password} -e "CREATE DATABASE #{database}"}
else
  adapter = 'postgresql'
  database = 'test_earth'
  username = nil
  password = nil
end

config = {
  'encoding' => 'utf8',
  'adapter' => adapter,
  'database' => database,
}
config['username'] = username if username
config['password'] = password if password

ActiveRecord::Base.establish_connection config

logger = Logger.new 'log/test.log'
logger.level = Logger::DEBUG

ActiveRecord::Base.logger = logger
DataMiner.logger = logger

DataMiner::Run.auto_upgrade!

RSpec.configure do |c|
  unless ENV['ALL'] == 'true'
    c.filter_run_excluding :data_miner => true
  end
end
