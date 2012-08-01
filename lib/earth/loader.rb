require 'earth'

module Earth
  module Loader
    def Loader.require_related(path)
      path = ::File.expand_path path
      raise ::ArgumentError, %{[earth gem] #{path} is not in #{LIB_DIR}} unless path.start_with?(LIB_DIR)
      domain = %r{#{LIB_DIR}/([^\./]+)}.match(path).captures.first
      require_domain domain, :mine_original_sources => path.include?('data_miner')
    end
    
    def Loader.require_all(options = {})
      require_glob ::File.join(LIB_DIR, '**', '*.rb'), options
    end
    
    def Loader.require_domain(domain, options = {})
      require_glob ::File.join(LIB_DIR, domain.to_s, '**', '*.rb'), options 
    end
    
    def Loader.require_glob(glob, options = {})
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
      end if options[:load_data_miner] || options[:mine_original_sources]
      nil
    end
    
    def Loader.load_plugins
      Dir[File.expand_path('../../../vendor/**/init.rb', __FILE__)].each do |pluginit|
        $LOAD_PATH.unshift ::File.join(::File.dirname(pluginit), 'lib')
        Kernel.load pluginit
      end
    end
  end
end
