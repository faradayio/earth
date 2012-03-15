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

case ENV['EARTH_DB_ADAPTER']
when 'mysql'
  adapter = 'mysql2'
  database = 'test_earth'
  username = 'root'
  password = 'password'
  
  # system %{mysql -u #{username} -p#{password} -e "DROP DATABASE #{database}"}
  # system %{mysql -u #{username} -p#{password} -e "CREATE DATABASE #{database}"}
when 'sqlite'
  adapter = 'sqlite3'
  database = ':memory:'
  username = nil
  password = nil
else
  adapter = 'postgresql'
  username = ENV['EARTH_POSTGRES_USERNAME'] || `whoami`.chomp
  password = ENV['EARTH_POSTGRES_PASSWORD']
  database = ENV['EARTH_POSTGRES_DATABASE'] || 'test_earth'

  createdb_bin = ENV['EARTH_CREATEDB_BIN'] || 'createdb'
  dropdb_bin = ENV['EARTH_DROPDB_BIN'] || 'dropdb'
  # system %{#{dropdb_bin} #{database}}
  # system %{#{createdb_bin} #{database}}
end

config = {
  'encoding' => 'utf8',
  'adapter' => adapter,
  'database' => database,
}
config['username'] = username if username
config['password'] = password if password

ActiveRecord::Base.establish_connection config

require 'earth'

domain = ARGV[0]

Earth.init domain, :load_data_miner => true, :apply_schemas => true
DataMiner::Run.create_tables

ActiveRecord::Base.logger = Logger.new $stderr
ActiveRecord::Base.logger.level = Logger::INFO

def show_resource(resource)
  resource_model = resource.constantize
  if (warnings = resource_model.table_warnings).any?
    $stderr.puts
    $stderr.puts '#'*50
    $stderr.puts "# #{resource}"
    $stderr.puts '#'*50
    $stderr.puts
    warnings.each do |warning|
      $stderr.puts "* #{warning}"
    end
  end
end

if (resource = ARGV[1].to_s.camelcase).present?
  resource.constantize.run_data_miner!
  show_resource resource
else
  DataMiner.run
  Earth.resources(domain).each do |resource|
    show_resource resource
  end
end
# ARGV[1].split(/[^a-z_]/i).each { |underscore| underscore.camelcase.constantize.run_data_miner! }
