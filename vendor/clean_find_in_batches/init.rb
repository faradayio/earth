# http://seejohncode.com/2011/09/16/uuids-and-find-in-batches
module CleanFindInBatches
  def self.included(base)
    base.class_eval do
      alias :old_find_in_batches :find_in_batches
      alias :find_in_batches :replacement_find_in_batches
    end
  end

  # Override this here because of the implementation of regular find_in_batches
  # conflicting with this class using UUIDs
  def replacement_find_in_batches(options = {}, &block)
    relation = self
    return old_find_in_batches(options, &block) if relation.primary_key.is_a?(::Arel::Attributes::Integer)
    # Throw errors like the real thing
    if (finder_options = options.except(:batch_size)).present?
      raise "You can't specify an order, it's forced to be #{batch_order}" if options[:order].present?
      raise "You can't specify a limit, it's forced to be the batch_size"  if options[:limit].present?
      raise 'You can\'t specify start, it\'s forced to be 0 because the ID is a string' if options.delete(:start)
      relation = apply_finder_options(finder_options)
    end
    # Compute the batch size
    batch_size = options.delete(:batch_size) || 1000
    offset = 0
    # Get the relation and keep going over it until there's nothing left
    relation = relation.except(:order).order(batch_order).limit(batch_size)
    while (results = relation.offset(offset).limit(batch_size).all).any?
      block.call results
      offset += batch_size
    end
    nil
  end
end

::ActiveRecord::Batches.send(:include, ::CleanFindInBatches)
