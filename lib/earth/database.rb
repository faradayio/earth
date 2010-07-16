module Earth
  class Database
    class << self
      def init(options = {})
        domains = case options[:earth]
        when :none then
          []
        when :all then
          all_domains.map(&:to_sym)
        else
          [options[:earth]]
        end
        domains.each { |d| read_schema(d) }
        load_all_schemas unless domains.empty?
      end

      def all_domains
        %w{air automobile bus diet locality pet rail residence}
      end

      def read_schema(domain)
        schema_path = File.join File.dirname(__FILE__), domain.to_s, 'schema.rb'
        load schema_path if File.exist? schema_path
      end

      def define_schema(&blk)
        @schemas = [] unless defined?(@schemas)
        @schemas << blk
      end

      def schemas
        @schemas
      end

      def load_all_schemas
        orig_std_out = STDOUT.clone
        STDOUT.reopen File.open(File.join('/tmp', 'schema_output'), 'w') 

        ActiveRecord::Schema.define(:version => 1) do
          ar_schema = self
          Earth::Database.schemas.each do |s|
            ar_schema.instance_eval &s
          end
        end
      ensure
        STDOUT.reopen(orig_std_out)
      end
    end
  end
end
