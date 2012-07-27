require 'active_support/core_ext'
require 'active_support/string_inquirer'
require 'active_record'
require 'data_miner'
require 'falls_back_on'
require 'weighted_average'
require 'fixed_width'
require 'errata'
require 'table_warnings'
require 'fuzzy_match'

require 'earth/utils'
require 'earth/conversions_ext'
require 'earth/inflectors'
require 'earth/loader'
require 'earth/warnings'

require 'earth/active_record_base_class_methods'
ActiveRecord::Base.extend Earth::ActiveRecordBaseClassMethods

# only included in resource classes
require 'earth/active_record_class_methods'

# The earth module is an interface for loading data models from various domains.
module Earth
  VENDOR_DIR = ::File.expand_path '../../vendor', __FILE__
  LIB_DIR = ::File.expand_path '../earth', __FILE__
  DATA_DIR = ::File.expand_path '../../data', __FILE__
  ERRATA_DIR = ::File.expand_path '../../errata', __FILE__

  # Earth.init is the gateway to using Earth. It will load any specified
  # domains, any needed ActiveRecord plugins, and will apply each domain
  # model's schema to the database if the :apply_schemas option is given.
  # (See .domains for the list of allowable domains and an explanation
  # of what a domain is)
  #
  # Earth.init should be performed after a connection is made to the database and 
  # before any domain models are referenced.
  #
  # @param [Symbol] domain domain to load, e.g. `:all` (optional)
  # @param [Hash] options load options
  # * :skip_parent_associations, if true, will not run data_miner on parent associations of a model. For instance, `Airport.run_data_miner!` will not data mine ZipCode, to which it belongs.
  # * :load_data_miner, if true, will load files necessary to data mine from scratch rather than via taps
  # * :apply_schemas will run `create_table!` on each model
  def Earth.init(*args)
    connect

    options = args.extract_options!
    domains = args
    domains << Earth.global_domain if domains.empty?

    Warnings.check_mysql_ansi_mode
    Loader.load_plugins
    
    if domains.include?(:none)
      # don't load anything
    elsif domains.include?(:all) or domains.empty?
      Loader.require_all options
    else
      domains.each do |domain|
        Loader.require_domain domain, options
      end
    end
    
    # be sure to look at both explicitly and implicitly loaded resources
    resources.select do |resource|
      ::Object.const_defined?(resource)
    end.each do |resource|
      resource_model = resource.constantize
      resource_model.extend Earth::ActiveRecordClassMethods
      script = resource_model.data_miner_script
      unless options[:skip_parent_associations]
        script.append_once :process, :run_data_miner_on_parent_associations!
      end
      if options[:load_data_miner]
        script.prepend_once :process, :create_table!
      else
        script.prepend_once :sql, "Brighter Planet's reference data", "http://data.brighterplanet.com/#{resource.underscore.pluralize}.sql"
      end
      if options[:apply_schemas]
        # FIXME TODO apply_schemas should really be reset_schemas or something
        resource_model.create_table! false
      end
    end
  end

  # Earth.domains lists the available domains that can be loaded by Earth.init.
  # A domain is merely a category into which related data models are placed. For 
  # instance, the `air` domain contains Airports, Airlines, Aircraft, and 
  # FlightSegments, which are historical records of actual flights.
  #
  # @return [Array] a list of domain names
  def Earth.domains
    @domains ||= ::Dir[::File.join(LIB_DIR, '*')].map do |path|
      if ::File.directory? path
        ::File.basename path
      end
    end.compact.uniq.sort
  end
  
  # List the currently loaded data model class names.
  #
  # @return [Array] a list of camelized resource names
  def Earth.resources(*search_domains)
    search_domains = search_domains.flatten.compact.map(&:to_s)
    if search_domains.empty?
      search_domains = domains
    end
    search_domains.map do |domain|
      ::Dir[::File.join(LIB_DIR, domain, '**', '*.rb')].map do |possible_resource|
        unless possible_resource.include?('data_miner')
          ::File.basename(possible_resource, '.rb').camelcase
        end
      end
    end.flatten.compact.sort
  end

  # Connect to the database according to current configurations in
  # Earth.database_configurations and the current environment in Earth.env.
  def Earth.connect
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(Earth.database_configurations[Earth.env])
    end
  end

  # The current environment. Earth detects the following environment variables:
  #
  # * EARTH_ENV (for CLI apps and daemons)
  # * RAILS_ENV
  # * RACK_ENV
  #
  # Default is `development`
  def Earth.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['EARTH_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] ||'development')
  end

  # If no domain is specified in Earth.init, the EARTH_DOMAIN environment 
  # variable can be used. Otherwise, `:all` is the default.
  def Earth.global_domain
    ENV['EARTH_DOMAIN'] ? ENV['EARTH_DOMAIN'].to_sym : :all
  end

  # Earth will load database connection parameters from 
  # config/database.yml (same as Rails' database configuration).
  # Otherwise, a default testing configuration is used.
  def Earth.database_configurations
    yaml_path = File.join(Dir.pwd, 'config/database.yml')
    if File.exist?(yaml_path)
      require 'yaml'
      YAML.load_file yaml_path
    else
      case ENV['EARTH_DB_ADAPTER']
      when 'mysql'
        adapter = 'mysql2'
        database = 'test_earth'
        username = 'root'
        password = 'password'
      else
        adapter = 'postgresql'
        database = 'test_earth'
        username = nil
        password = nil
      end

      config = {
        'test' => {
          'encoding' => 'utf8',
          'adapter' => adapter,
          'database' => database,
        }
      }

      config['username'] = username if username
      config['password'] = password if password

      config
    end
  end

  # Run data miner on all currently loaded data models.
  #
  # @note By default, data is mined from data.brighterplanet.com 
  # via taps. In order to mine from scratch, call Earth.init 
  # with the :load_data_miner option.
  def Earth.run_data_miner!
    resources.select do |resource|
      Object.const_defined?(resource)
    end.each do |resource|
      resource.constantize.run_data_miner!
    end
  end

  # The logger object
  def Earth.logger
    @logger ||= Logger.new 'log/test.log'
  end
end
