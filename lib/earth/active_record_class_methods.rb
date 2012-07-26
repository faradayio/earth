module Earth
  module ActiveRecordClassMethods
    # http://ostermiller.org/findcomment.html
    COMMENT = %r{/\*(?:.|[\r\n])*?\*/}
    WHITESPACE = /\s+/
    SEMICOLON = / ?; ?/

    def create_table!(force = true)
      c = ActiveRecord::Base.connection_pool.checkout

      if c.table_exists?(table_name) and not force
        return
      end

      c.execute %{DROP TABLE IF EXISTS "#{table_name}"}

      statements = const_get(:TABLE_STRUCTURE).gsub(COMMENT, '').gsub(WHITESPACE, ' ').split(SEMICOLON).select(&:present?)

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
end
