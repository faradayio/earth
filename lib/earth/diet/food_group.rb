class FoodGroup < ActiveRecord::Base
  set_primary_key :name

  class << self
    def names
      connection.select_values arel_table.project(:name).to_sql
    end
    
    def [](name)
      find_by_name name.to_s
    end
  end
  
  data_miner do
    tap "Brighter Planet's food group data", Earth.taps_server
  end
end
