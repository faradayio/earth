require 'rubygems'
require 'bundler'

Bundler.setup

require 'data_miner'
DataMiner.logger = Logger.new(nil)

require 'sniff'
Sniff.init File.expand_path('../..', File.dirname(__FILE__)), :earth => :all, :cucumber => true
