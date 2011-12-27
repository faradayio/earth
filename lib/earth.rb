require 'active_support/core_ext'
require 'active_record'
require 'cohort_scope'
require 'earth/conversions_ext'
require 'earth/inflectors'
require 'data_miner'
require 'falls_back_on'
require 'weighted_average'
require 'fixed_width'
require 'errata'
require 'mini_record'
require 'table_warnings'
require 'loose_tight_dictionary'
require 'loose_tight_dictionary/cached_result'
require 'earth/utils'

# The earth module is an interface for loading data models from various domains.
module Earth
  extend ::ActiveSupport::Memoizable
  extend self

  def domains
    ::Dir[::File.join(lib_dir, '*')].map do |path|
      if ::File.directory? path
        ::File.basename path
      end
    end.compact.uniq.sort
  end
  memoize :domains
  
  def resources(*search_domains)
    search_domains = search_domains.flatten.compact.map(&:to_s)
    if search_domains.empty?
      search_domains = domains
    end
    search_domains.map do |domain|
      ::Dir[::File.join(lib_dir, domain, '**', '*.rb')].map do |possible_resource|
        unless possible_resource.include?('data_miner')
          ::File.basename(possible_resource, '.rb').camelcase
        end
      end
    end.flatten.compact.sort
  end
  memoize :resources

  def gem_root
    ::File.expand_path '../..', __FILE__
  end
  
  def lib_dir
    ::File.expand_path '../earth', __FILE__
  end

  # Earth.init will load any specified domains, any needed ActiveRecord plugins, 
  # and will apply each domain model's schema to the database if the 
  # :apply_schemas option is given. See Earth.domains for the list of allowable 
  # domains.
  #
  # Earth.init should be performed after a connection is made to the database and 
  # before any domain models are referenced.
  def init(*args)
    options = args.extract_options!
    domains = args

    options[:load_data_miner] = true if options[:apply_schemas]

    _warn_unless_mysql_ansi_mode
    _load_plugins
    
    if domains.include?(:none)
      # don't load anything
    elsif domains.empty?
      require_all options
    else
      domains.each do |domain|
        require_domain domain, options
      end
    end
    
    # be sure to look at both explicitly and implicitly loaded resources
    resources.each do |resource|
      next unless ::Object.const_defined?(resource)
      resource_model = resource.constantize
      
      _append_pull_dependencies_step_to_data_miner resource_model

      if options[:load_data_miner]
        _prepend_auto_upgrade_step_to_data_miner resource_model
      else
        _prepend_taps_step_to_data_miner resource_model
      end

      if options[:apply_schemas]
        resource_model.auto_upgrade!
      end
    end
  end

  # internal use
  def require_related(path)
    path = ::File.expand_path path
    raise ::ArgumentError, %{[earth gem] #{path} is not in #{lib_dir}} unless path.start_with?(lib_dir)
    domain = %r{#{lib_dir}/([^\./]+)}.match(path).captures.first
    require_domain domain, :load_data_miner => path.include?('data_miner')
  end
  
  # internal use
  def require_all(options = {})
    require_glob ::File.join(lib_dir, '**', '*.rb'), options
  end

  private
  
  def require_domain(domain, options = {})
    require_glob ::File.join(lib_dir, domain, '**', '*.rb'), options 
  end
  
  def require_glob(glob, options = {})
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
  memoize :require_glob
  
  def _warn_unless_mysql_ansi_mode
    if ::ActiveRecord::Base.connection.adapter_name =~ /mysql/i
      sql_mode = ::ActiveRecord::Base.connection.select_value("SELECT @@GLOBAL.sql_mode") + ::ActiveRecord::Base.connection.select_value("SELECT @@SESSION.sql_mode")
      $stderr.puts "[earth gem] Warning: MySQL detected, but PIPES_AS_CONCAT not set. Importing from scratch will fail. Consider setting sql-mode=ANSI in my.cnf." unless sql_mode =~ /pipes_as_concat/i
    end
  end
  
  def _load_plugins
    ::Dir[::File.expand_path('../../vendor/**/init.rb', __FILE__)].each do |pluginit|
      $LOAD_PATH.unshift ::File.join(::File.dirname(pluginit), 'lib')
      ::Kernel.load pluginit
    end
  end
  
  def _append_pull_dependencies_step_to_data_miner(resource_model)
    return if resource_model.data_miner_config.steps.any? { |step| step.description == :run_data_miner_on_parent_associations! }

    pull_dependencies_step = DataMiner::Process.new resource_model.data_miner_config, :run_data_miner_on_parent_associations!

    resource_model.data_miner_config.steps.push pull_dependencies_step
  end
  
  def _prepend_auto_upgrade_step_to_data_miner(resource_model)
    return if resource_model.data_miner_config.steps.any? { |step| step.description == :auto_upgrade! }

    auto_upgrade_step = DataMiner::Process.new resource_model.data_miner_config, :auto_upgrade!

    resource_model.data_miner_config.steps.unshift auto_upgrade_step
  end
  
  TAPS_STEP = 'Tap the Brighter Planet data server'
  TAPS_SOURCE = 'http://carbon:neutral@data.brighterplanet.com:5000'
  def _prepend_taps_step_to_data_miner(resource_model)
    return if resource_model.data_miner_config.steps.any? { |step| step.description == TAPS_STEP }
    
    taps_step = DataMiner::Tap.new resource_model.data_miner_config, TAPS_STEP, TAPS_SOURCE
    
    resource_model.data_miner_config.steps.unshift taps_step
  end
end
