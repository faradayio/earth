require 'active_support/core_ext'
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

# The earth module is an interface for loading data models from various domains.
module Earth
  TAPS_SOURCE = 'http://carbon:neutral@data.brighterplanet.com:5000'
  TAPS_DESCRIPTION = "Brighter Planet's reference data web service"
  VENDOR_DIR = ::File.expand_path '../../vendor', __FILE__
  LIB_DIR = ::File.expand_path '../earth', __FILE__
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
    options = args.extract_options!
    domains = args

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
      resource_model.data_miner_script.append_once :process, :run_data_miner_on_parent_associations!
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
end
# TODO move this into a gem or into its own namespace in this gem
require ::File.join(Earth.vendor_dir, 'clean_find_in_batches', 'init')
