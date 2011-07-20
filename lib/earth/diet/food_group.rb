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
  
  force_schema do
    string  'name'
    float   'intensity'
    string  'intensity_units'
    float   'energy'
    string  'energy_units'
    string  'suggested_imperial_measurement' # ?
  end
end
