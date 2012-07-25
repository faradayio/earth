require 'active_support/core_ext'
require 'active_support/string_inquirer'
require 'active_record'
require 'data_miner'
require 'falls_back_on'
require 'weighted_average'
require 'fixed_width'
require 'errata'
require 'active_record_inline_schema'
require 'table_warnings'
require 'fuzzy_match'

require 'earth/utils'
require 'earth/conversions_ext'
require 'earth/inflectors'

require 'earth/active_record_base_class_methods'
ActiveRecord::Base.extend Earth::ActiveRecordBaseClassMethods

# The earth module is an interface for loading data models from various domains.
module Earth
  TAPS_SOURCE = 'http://carbon:neutral@data.brighterplanet.com:5000'
  TAPS_DESCRIPTION = "Brighter Planet's reference data web service"
  VENDOR_DIR = ::File.expand_path '../../vendor', __FILE__
  LIB_DIR = ::File.expand_path '../earth', __FILE__
  DATA_DIR = ::File.expand_path '../../data', __FILE__
  ERRATA_DIR = ::File.expand_path '../../errata', __FILE__

  def Earth.domains
    @domains ||= ::Dir[::File.join(LIB_DIR, '*')].map do |path|
      if ::File.directory? path
        ::File.basename path
      end
    end.compact.uniq.sort
  end
  
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

  # Earth.init will load any specified domains, any needed ActiveRecord plugins, 
  # and will apply each domain model's schema to the database if the 
  # :apply_schemas option is given. See Earth.domains for the list of allowable 
  # domains.
  #
  # Earth.init should be performed after a connection is made to the database and 
  # before any domain models are referenced.
  def Earth.init(*args)
    connect

    options = args.extract_options!
    domains = args
    domains << Earth.global_domain if domains.empty?

    warn_unless_mysql_ansi_mode
    load_plugins
    
    if domains.include?(:none)
      # don't load anything
    elsif domains.include?(:all) or domains.empty?
      require_all options
    else
      domains.each do |domain|
        require_domain domain, options
      end
    end
    
    # be sure to look at both explicitly and implicitly loaded resources
    resources.select do |resource|
      ::Object.const_defined?(resource)
    end.each do |resource|
      resource_model = resource.constantize
      unless options[:skip_parent_associations]
        resource_model.data_miner_script.append_once :process, :run_data_miner_on_parent_associations!
      end
      if options[:load_data_miner]
        resource_model.data_miner_script.prepend_once :process, :auto_upgrade!
      else
        resource_model.data_miner_script.prepend_once :tap, TAPS_DESCRIPTION, TAPS_SOURCE
      end
      if options[:apply_schemas]
        resource_model.auto_upgrade!
      end
    end
  end

  def Earth.connect
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(Earth.database_configurations[Earth.env])
    end
  end

  # internal use
  def Earth.require_related(path)
    path = ::File.expand_path path
    raise ::ArgumentError, %{[earth gem] #{path} is not in #{LIB_DIR}} unless path.start_with?(LIB_DIR)
    domain = %r{#{LIB_DIR}/([^\./]+)}.match(path).captures.first
    require_domain domain, :load_data_miner => path.include?('data_miner')
  end
  
  # internal use
  def Earth.require_all(options = {})
    require_glob ::File.join(LIB_DIR, '**', '*.rb'), options
  end
  
  private
  
  def Earth.require_domain(domain, options = {})
    require_glob ::File.join(LIB_DIR, domain.to_s, '**', '*.rb'), options 
  end
  
  def Earth.require_glob(glob, options = {})
    @require_glob ||= []
    args = [glob, options]
    return if @require_glob.include?(args)
    @require_glob << args
    data_miner_paths = []
    ::Dir[glob].each do |path|
      if path.include?('data_miner')
        data_miner_paths << path
      else
        require path
      end
    end
    # load data_miner blocks second to make sure they override
    data_miner_paths.each do |path|
      require path
    end if options[:load_data_miner]
    nil
  end
  
  def Earth.warn_unless_mysql_ansi_mode
    if ::ActiveRecord::Base.connection.adapter_name =~ /mysql/i
      sql_mode = ::ActiveRecord::Base.connection.select_value("SELECT @@GLOBAL.sql_mode") + ::ActiveRecord::Base.connection.select_value("SELECT @@SESSION.sql_mode")
      unless sql_mode.downcase.include? 'pipes_as_concat'
        ::Kernel.warn "[earth gem] Warning: MySQL detected, but PIPES_AS_CONCAT not set. Importing from scratch will fail. Consider setting sql-mode=ANSI in my.cnf."
      end
    end
  end
  
  def Earth.load_plugins
    ::Dir[::File.expand_path('../../vendor/**/init.rb', __FILE__)].each do |pluginit|
      $LOAD_PATH.unshift ::File.join(::File.dirname(pluginit), 'lib')
      ::Kernel.load pluginit
    end
  end

  def Earth.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['EARTH_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] ||'development')
  end

  def Earth.global_domain
    ENV['EARTH_DOMAIN'] ? ENV['EARTH_DOMAIN'].to_sym : :all
  end

  def Earth.database_configurations
    yaml_path = File.join(Dir.pwd, 'config/database.yml')
    if File.exist?(yaml_path)
      require 'yaml'
      YAML::load_file yaml_path
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

  def Earth.run_data_miner!
    resources.select do |resource|
      Object.const_defined?(resource)
    end.each do |resource|
      resource.constantize.run_data_miner!
    end
  end

  def Earth.logger
    @logger ||= Logger.new 'log/test.log'
  end
end
