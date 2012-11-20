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
      require_later = []
      ::Dir[glob].each do |path|
        # ugh
        if path.include?('data_miner') or path.include?('parser')
          require_later << path
        else
          require path
        end
      end
      # load data_miner blocks second to make sure they override
      require_later.each do |path|
        require path
      end if options[:load_data_miner] || options[:mine_original_sources]
      nil
    end
  end
end
