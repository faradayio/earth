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

ActiveRecord::Base.establish_connection(
  'adapter' => 'mysql',
  'database' => 'test_earth',
  'username' => 'root',
  'password' => 'password'
)

require 'earth'

Earth.init ARGV[0], :load_data_miner => true, :apply_schemas => true

ARGV[1].camelcase.constantize.run_data_miner!
