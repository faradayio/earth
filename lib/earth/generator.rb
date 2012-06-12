require 'active_support/core_ext'

module Earth
  module Generator
    def Generator.domains
      Dir[File.expand_path('../*', __FILE__)].map do |path|
        if File.directory? path
          File.basename path
        end
      end.compact.uniq.sort
    end

    def Generator.resources
      domains.map do |domain|
        Dir[File.expand_path(File.join('../', domain, '**', '*.rb'), __FILE__)].map do |possible_resource|
          unless possible_resource.include?('data_miner')
            File.basename(possible_resource, '.rb').camelcase
          end
        end
      end.flatten.compact.sort
    end

    def Generator.generate
      File.open 'lib/earth/resources.rb', 'w' do |f|
        f.puts <<-RUBY
module Earth
  RESOURCES = #{resources.inspect}
end
        RUBY
      end
    end
  end
end

