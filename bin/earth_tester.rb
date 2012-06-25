#!/usr/bin/env ruby

unless RUBY_VERSION >= '1.9'
  require 'rubygems'
end

if File.exist?(File.join(Dir.pwd, 'earth.gemspec'))
  require 'bundler'
  Bundler.setup
  if Bundler.definition.specs['debugger'].first
    require 'debugger'
  elsif Bundler.definition.specs['ruby-debug'].first
    require 'ruby-debug'
  end
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
end

require 'active_support/all'
require 'active_record'

case ENV['DATABASE']
when /postgr/i
  system %{dropdb test_earth}
  system %{createdb test_earth}
  ActiveRecord::Base.establish_connection(
    'adapter' => 'postgresql',
    'encoding' => 'utf8',
    'database' => 'test_earth',
    'username' => `whoami`.chomp
  )
when /sqlite/i
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
else
  system %{mysql -u root -ppassword -e "DROP DATABASE test_earth"} if ENV['RESET_DB'] == 'true'
  system %{mysql -u root -ppassword -e "CREATE DATABASE test_earth CHARSET utf8"}
  ActiveRecord::Base.establish_connection(
    'adapter' => (RUBY_PLATFORM == 'java' ? 'mysql' : 'mysql2'),
    'encoding' => 'utf8',
    'database' => 'test_earth',
    'username' => 'root',
    'password' => 'password'
  )
end

require 'earth'

DataMiner.unit_converter = :conversions

DataMiner::Run.auto_upgrade!

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

def init(domain)
  Earth.init domain, :load_data_miner => true, :apply_schemas => true
end

if ARGV[0]
  init ARGV[0]
end

require 'pry'
Pry.color = false

# you prob want to init() something
binding.pry
