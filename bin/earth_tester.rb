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

require 'thor'

class EarthTester < Thor
  desc :console, "Get a console"
  method_option :domains, :type => :array, :default => []
  method_option :database, :type => :string, :default => 'mysql'
  method_option :reset, :type => :boolean, :desc => 'Fully reset databases'
  method_option :load_data_miner, :type => :boolean, :desc => "Load full data_miner blocks"
  method_option :apply_schemas, :type => :boolean, :desc => "Immediately apply table schemas"
  def console
    earth_options = options.inject({}) do |memo, (k, v)|
      k = k.to_sym
      if [:load_data_miner, :apply_schemas].include?(k)
        memo[k] = v
      end
      memo
    end
    environment
    Earth.init(*(options.domains.map(&:to_sym)+[earth_options]))
    require 'pry'
    Pry.color = false
    binding.pry
  end

  private
  
  def environment
    require 'active_support/all'
    require 'active_record'

    # TODO convert to @dkastner's Earth.database_configurations
    case options.database
    when /postgr/i
      if options.reset
        system %{dropdb test_earth}
        system %{createdb test_earth}
      end
      ActiveRecord::Base.establish_connection(
        'adapter' => 'postgresql',
        'encoding' => 'utf8',
        'database' => 'test_earth',
        'username' => `whoami`.chomp
      )
    when /sqlite/i
      if options.reset
        FileUtils.rm_f 'earth_tester.sqlite3'
      end
      ActiveRecord::Base.establish_connection('adapter' => 'sqlite3', 'database' => 'earth_tester.sqlite3')
    when /mysql/i
      if options.reset
        system %{mysql -u root -ppassword -e "DROP DATABASE test_earth"}
        system %{mysql -u root -ppassword -e "CREATE DATABASE test_earth CHARSET utf8"}
      end
      ActiveRecord::Base.establish_connection(
        'adapter' => (RUBY_PLATFORM == 'java' ? 'mysql' : 'mysql2'),
        'encoding' => 'utf8',
        'database' => 'test_earth',
        'username' => 'root',
        'password' => 'password'
      )
    else
      raise "not sure what database to connect to - #{options.database.inspect}"
    end

    require 'earth'

    DataMiner.unit_converter = :conversions

    DataMiner::Run.auto_upgrade!

    ActiveRecord::Base.logger = Logger.new $stdout
    ActiveRecord::Base.logger.level = Logger::DEBUG
  end
end

EarthTester.start
