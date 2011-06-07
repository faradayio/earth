require 'active_record'
require 'cohort_scope'
require 'earth/conversions_ext'
require 'earth/inflectors'
require 'data_miner'
require 'falls_back_on'
require 'weighted_average'
require 'fixed_width'
require 'errata'
require 'create_table'
require 'earth/active_record_ext'

# The earth module is an interface for loading data models from various domains.
module Earth
  extend self

  # Takes argument like Earth.search(['air'])
  # Default is search all domains
  # For example, <tt>[ 'Aircraft', 'Airline' ]</tt>
  def search(search_domains = :all)
    if search_domains == :all
      resources
    else
      resource_map.select do |resource, domain|
        search_domains.include? domain.to_sym
      end.map do |resource, domain|
        resource
      end
    end
  end

  def gem_root 
    File.expand_path File.join(File.dirname(__FILE__), '..')
  end

  def domains
    resource_map.values.uniq.sort
  end
  
  def resources
    resource_map.keys.sort
  end

  def resource_map
    @resource_map ||= Dir[File.join(gem_root, 'lib', 'earth', '*')].select do |path|
      File.directory? path
    end.inject({}) do |memo, domain_path|
      Dir[File.join(domain_path, '*.rb')].each do |resource_path|
        resource = File.basename(resource_path, '.rb').camelcase
        unless resource == 'DataMiner'
          memo[resource] = File.basename domain_path
        end
      end
      memo
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
    options = args.last.is_a?(Hash) ? args.pop.symbolize_keys : {}
    domains = args.empty? ? [ :all ] : args.map(&:to_sym)
    selected_resources = search domains

    _load_plugins
    _load_domains domains, options
    _decorate_resources selected_resources, options
    _load_schemas selected_resources, options
  end

  private
  
  # TODO sabshere don't use directories to specify domains
  # * you have 20 million data_miner.rb files which are easy to confuse
  # * you have to go all over the filesystem to figure things out
  def _load_domains(domains, options)
    if domains.empty? or domains.include?(:all)
      # sabshere 9/16/10 why maintain this separately?
      require 'earth/all'
      require 'earth/data_miner' if options[:apply_schemas] or options[:load_data_miner]
    else
      domains.each do |domain| 
        require "earth/#{domain}"
        require "earth/#{domain}/data_miner" if options[:apply_schemas] or options[:load_data_miner]
      end
    end
  end

  def _load_plugins
    Dir[File.join(Earth.gem_root, 'vendor', '**', 'init.rb')].each do |pluginit|
      $:.unshift File.join(File.dirname(pluginit), 'lib')
      load pluginit
    end
  end
  
  CREATE_TABLE_STEP = 'Create a table using the create_table gem'
  TAPS_STEP = 'Tap the Brighter Planet data server'
  TAPS_SOURCE = 'http://carbon:neutral@data.brighterplanet.com'
  PULL_DEPEDENCIES_STEP = 'Pull dependencies implied by belongs-to associations'
  
  def _decorate_resources(selected_resources, options)
    selected_resources.each do |resource|
      resource_model = resource.constantize
      unless resource_model.data_miner_config.steps.any? { |step| step.description == PULL_DEPEDENCIES_STEP }
        pull_dependencies_step = DataMiner::Process.new(resource_model.data_miner_config, PULL_DEPEDENCIES_STEP) do
          resource_model.run_data_miner_on_belongs_to_associations
        end
        resource_model.data_miner_config.steps.unshift pull_dependencies_step
      end
      if options[:apply_schemas] or options[:load_data_miner]
        unless resource_model.data_miner_config.steps.any? { |step| step.description == CREATE_TABLE_STEP }
          create_table_step = DataMiner::Process.new(resource_model.data_miner_config, CREATE_TABLE_STEP) do
            resource_model.create_table!
          end
          resource_model.data_miner_config.steps.unshift create_table_step
        end
      else
        # LIFO
        unless resource_model.data_miner_config.steps.any? { |step| step.description == TAPS_STEP }
          resource_model.data_miner_config.steps.unshift DataMiner::Tap.new(resource_model.data_miner_config, TAPS_STEP, TAPS_SOURCE)
        end
      end
    end
  end
  
  def _load_schemas(selected_resources, options)
    return unless options[:apply_schemas] or options[:load_data_miner]
    selected_resources.each do |resource|
      resource.constantize.create_table!
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
