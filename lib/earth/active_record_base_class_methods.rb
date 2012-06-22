module Earth
  module ActiveRecordBaseClassMethods
    # http://www.seejohncode.com/tag/rails/
    # Override due to implementation of regular find_in_batches conflicting using UUIDs
    def safe_find_in_batches(options = {}, &block)
      relation = self
      return find_in_batches(options, &block) if relation.primary_key.is_a?(Arel::Attributes::Integer)

      batch_size = options.fetch(:batch_size, 1000)
      batch_order = "#{quoted_table_name}.#{quoted_primary_key} ASC"
      # Throw errors like the real thing
      if (finder_options = options.except(:batch_size)).any?
        raise "You can't specify an order, it's forced to be #{batch_order}" if options.has_key?(:order)
        raise "You can't specify a limit, it's forced to be the batch_size" if options.has_key?(:limit)
        raise "You can't specify start, it's forced to be 0 because the ID is a string" if options.has_key?(:start)
        relation = apply_finder_options(finder_options)
      end

      offset = 0
      # Get the relation and keep going over it until there's nothing left
      relation = relation.except(:order).order(batch_order).limit(batch_size)
      while (results = relation.offset(offset).limit(batch_size).all).any?
        block.call results
        offset += batch_size
      end
      nil
    end

    def safe_find_each(options = {})
      safe_find_in_batches(options) do |records|
        records.each { |record| yield record }
      end
    end
  end
end
