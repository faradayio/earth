class FoodGroup < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "food_groups"
  (
     "name"                           CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "intensity"                      FLOAT,
     "intensity_units"                CHARACTER VARYING(255),
     "energy"                         FLOAT,
     "energy_units"                   CHARACTER VARYING(255),
     "suggested_imperial_measurement" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"

  class << self
    def names
      connection.select_values arel_table.project(:name).to_sql
    end
    
    def [](name)
      find_by_name name.to_s
    end
  end
  
  warn_unless_size 10
end
