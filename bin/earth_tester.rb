#!/usr/bin/env ruby

unless RUBY_VERSION >= '1.9'
  require 'rubygems'
end

if File.exist?(File.join(Dir.pwd, 'earth.gemspec'))
  require 'bundler'
  Bundler.setup
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
end

require 'active_support/all'
require 'active_record'

# postgres
createdb_bin = ENV['TEST_CREATEDB_BIN'] || 'createdb'
dropdb_bin = ENV['TEST_DROPDB_BIN'] || 'dropdb'
username = ENV['TEST_POSTGRES_USERNAME'] || `whoami`.chomp
# password = ENV['TEST_POSTGRES_PASSWORD'] || 'password'
database = ENV['TEST_POSTGRES_DATABASE'] || 'test_earth'
system %{#{dropdb_bin} #{database}}
system %{#{createdb_bin} #{database}}

# TODO mysql

ActiveRecord::Base.establish_connection(
  'adapter' => 'postgresql',
  'encoding' => 'utf8',
  'database' => database,
  'username' => username,
  # 'password' => password
)

require 'earth'

Earth.init ARGV[0], :load_data_miner => true, :apply_schemas => true

ActiveRecord::Base.logger = Logger.new $stderr
ActiveRecord::Base.logger.level = Logger::INFO

ARGV[1].camelcase.constantize.run_data_miner!
