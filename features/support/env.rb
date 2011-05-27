require 'rubygems'
require 'bundler'

Bundler.setup

require 'earth'

require 'data_miner'
DataMiner.logger = Logger.new 'log/test.log'

require 'active_record'
require 'sqlite3'
ActiveRecord::Base.logger = Logger.new 'log/test.log'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
Earth.init :all, :apply_schemas => true
