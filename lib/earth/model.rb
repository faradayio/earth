require 'earth'
require 'table_warnings'

module Earth
  module Model
    def Model.extended(target)
      target.extend Mining
      target.extend SafeFinders
      target.extend Schema
      target.mattr_accessor :source_file
      self.registry << target
      target.source_file = caller.first.split(':').first
    end

    def Model.registry
      @registry ||= []
    end

    module Mining
      def run_data_miner!
        unless Earth.skip_parent_associations
          data_miner_script.append_once :process, :run_data_miner_on_parent_associations!
        end
        if Earth.mine_original_sources
          mine_original_sources
        else
          mine_brighterplanet
        end
        super
      end

      def mine_original_sources
        data_miner_script.prepend_once :process, :create_table!
        require File.join(File.dirname(source_file), File.basename(source_file, '.rb'), 'data_miner')
      end

      def mine_brighterplanet
        data_miner_script.prepend_once :sql, "Brighter Planet's reference data", "http://data.brighterplanet.com/#{to_s.underscore.pluralize}.sql"
      end
    end
    
    module Schema
      # http://ostermiller.org/findcomment.html
      COMMENT = %r{/\*(?:.|[\r\n])*?\*/}
      WHITESPACE = /\s+/
      SEMICOLON = / ?; ?/
      SQLITE = /sqlite/i
      ALTER_TABLE = /ALTER TABLE.*PRIMARY KEY/

      def create_table!(force = true)
        c = ActiveRecord::Base.connection_pool.checkout

        if c.table_exists?(table_name) and not force
          return
        end

        c.execute %{DROP TABLE IF EXISTS "#{table_name}"}

        statements = const_get(:TABLE_STRUCTURE).gsub(COMMENT, '').gsub(WHITESPACE, ' ').split(SEMICOLON).select(&:present?)

        # change how primary keys are defined if we're using sqlite
        if c.adapter_name =~ SQLITE
          # ALTER TABLE "flight_segments" ADD PRIMARY KEY ("row_hash")
          idx = statements.index { |sql| sql =~ ALTER_TABLE }
          statements[idx] = %{CREATE UNIQUE INDEX "index_#{table_name}_on_#{primary_key}" ON "#{table_name}" ("#{primary_key}")}
        end

        statements.each do |sql|
          c.execute sql
        end

        # safely reset column information
        if c.respond_to?(:schema_cache)
          c.schema_cache.clear!
        end
        reset_column_information
        descendants.each do |descendant|
          descendant.reset_column_information
        end

        nil
      ensure
        ActiveRecord::Base.connection_pool.checkin c
      end
    end

    module SafeFinders
      # http://www.seejohncode.com/tag/rails/
      # Override due to implementation of regular find_in_batches conflicting using UUIDs
      def safe_find_in_batches(&block)
        return find_in_batches({}, &block) if relation.primary_key.is_a?(Arel::Attributes::Integer)

        batch_size = 1000
        offset = 0
        # Get the relation and keep going over it until there's nothing left
        relation = order("#{quoted_table_name}.#{quoted_primary_key} ASC").limit(batch_size)
        while (results = relation.offset(offset).limit(batch_size).all).any?
          unscoped { block.call(results) }
          offset += batch_size
        end
        nil
      end

      def safe_find_each
        safe_find_in_batches do |records|
          records.each { |record| yield record }
        end
      end
    end
  end
end