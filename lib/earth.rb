require 'active_record'
require 'cohort_scope'
require 'earth/base'
require 'earth/conversions_ext'
require 'earth/inflectors'
require 'data_miner'
require 'falls_back_on'
require 'weighted_average'
require 'loose_tight_dictionary'
require 'slither'
require 'errata'

# The earth module is an interface for establishing a taps server (used to fetch 
# data) and for loading data models from various domains.
module Earth
  extend self

  def taps_server
    @taps_server || 'http://carbon:neutral@data.brighterplanet.com:5000'
  end

  # taps_server is a URL. See the data_miner gem docs
  def taps_server=(val)
    @taps_server = val
  end
  
  # Takes argument like Earth.resource_names(['air'])
  # Default is search all domains
  # For example, <tt>[ 'Aircraft', 'Airline' ]</tt>
  def resource_names(search_domains = nil)
    if search_domains.nil?
      resources.keys
    else
      resources.inject([]) do |list, (name, data)|
        list << name if search_domains.include? data[:domain]
        list
      end
    end
  end

  def gem_root 
    File.expand_path File.join(File.dirname(__FILE__), '..')
  end

  def domains
    @domains ||= resources.map { |(name, data)| data[:domain] }.uniq.sort
  end

  def resources
    return @resources unless @resources.nil?
    earth_files = Dir[File.join(Earth.gem_root, 'lib', 'earth', '*')]
    domain_dirs = earth_files.find_all { |f| File.directory?(f) }
    @resources = domain_dirs.inject({}) do |hsh, domain_dir|
      Dir[File.join(domain_dir, '*.rb')].each do |resource_file|
        resource_camel = File.basename(resource_file, '.rb').camelcase
        unless resource_camel == 'DataMiner'
          hsh[resource_camel] = { :domain => File.basename(domain_dir) }
        end
      end
      hsh
    end
  end

  # Earth.init will load any specified domains, any needed ActiveRecord plugins, 
  # and will apply each domain model's schema to the database if the 
  # :apply_schemas option is given. See Earth.domains for the list of allowable 
  # domains.
  #
  # Earth.init should be performed after a connection is made to the database and 
  # before any domain models are referenced.
  def init(*args)
    load_plugins

    domains = []
    options = {}
    args.each do |arg|
      if arg.is_a?(Hash)
        options = arg
      else
        domains << arg
      end
    end

    load_domains(domains, options)
    load_schemas(options) if options[:apply_schemas]
  end

  def database_options
    if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
      {}
    else
      { :options => 'ENGINE=InnoDB default charset=utf8 collate=utf8_general_ci' }
    end
  end

private
  def load_domains(domains, options)
    if domains.empty? or domains.include?(:all)
      # sabshere 9/16/10 why maintain this separately?
      require 'earth/all'
      require 'earth/data_miner' if options[:apply_schemas] or options[:load_data_miner]
    elsif !domains.include?(:none)
      domains.each do |domain| 
        require "earth/#{domain}"
        if options[:apply_schemas] or options[:load_data_miner]
          begin
            require "earth/#{domain}/data_miner"
          rescue LoadError
          end
        end
      end
    end
  end

  def load_plugins
    require 'earth/active_record_ext'
    Dir[File.join(Earth.gem_root, 'vendor', '**', 'init.rb')].each do |pluginit|
      $:.unshift File.join(File.dirname(pluginit), 'lib')
      load pluginit
    end
  end

  def load_schemas(options = {})
    load_data_miner_schemas(options)
  end

  def load_data_miner_schemas(options = {})
    models = Module.constants.select do |k|
      const = Object.const_get(k) if Object.const_defined?(k)
      if const.instance_of?(Class)
        const.superclass == ActiveRecord::Base || 
          const.superclass == Earth::Base
      else
        false
      end
    end
    models.sort.each do |model|
      klass = Object.const_get(model)
      if klass.respond_to?(:execute_schema) and (!klass.table_exists? || options[:force_schema])
        klass.execute_schema 
      end
    end
  end
end

def INSERT_IGNORE(cmd)
  if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
    prefix = 'INSERT'
  else
    prefix = 'INSERT IGNORE'
  end
  ActiveRecord::Base.connection.execute "#{prefix} #{cmd}"
end
