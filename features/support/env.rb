require 'rubygems'
require 'bundler'

Bundler.setup

require 'sniff'
Sniff.init File.expand_path('../..', File.dirname(__FILE__)), :earth => :all, :cucumber => true
