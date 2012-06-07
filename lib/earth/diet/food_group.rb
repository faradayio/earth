class FoodGroup < ActiveRecord::Base
  self.primary_key = "name"

  class << self
    def names
      connection.select_values arel_table.project(:name).to_sql
    end
    
    def [](name)
      find_by_name name.to_s
    end
  end
  
  col :name
  col :intensity, :type => :float
  col :intensity_units
  col :energy, :type => :float
  col :energy_units
  col :suggested_imperial_measurement # ?

  warn_unless_size 10
end
