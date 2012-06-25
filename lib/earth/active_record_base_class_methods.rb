module Earth
  module ActiveRecordBaseClassMethods
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
