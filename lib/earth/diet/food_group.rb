class FoodGroup < ActiveRecord::Base
  set_primary_key :name
  
  extend Cacheable if Switches.caching?
  
  data_miner do
    tap "Brighter Planet's food group data", Earth.taps_server
  end
  
  class << self
    def names
      connection.select_values arel_table.project(:name).to_sql#{}"SELECT name FROM food_groups"
    end
    cacheify :names if Switches.caching?
    
    def [](name)
      find_by_name name.to_s
    end
  end
  
  if Switches.caching?
    after_save :clear_cache
    after_destroy :clear_cache
    def clear_cache
      self.class.uncacheify_all
      true
    end
  end
  
end
