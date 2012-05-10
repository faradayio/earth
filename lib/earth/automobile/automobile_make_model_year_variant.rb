class AutomobileMakeModelYearVariant < ActiveRecord::Base
  self.primary_key = "row_hash"
  
  # It looks like synthesizing a unique name would require including pretty much every column from the FEGs
  # (e.g. creeper gear, automatic vs automatic with lockup, feedback fuel system, etc.)
  # The advantages of not keying on row_hash is we could update variants to note whether they're hybrid or not and
  # it would let users specify variants. But my conclusion is that trying to do this won't be much of an improvement
  # because it will be a bunch of work to include all the columns and the names will be really long and obtuse
  # -Ian 10/18/2011
  
  col :row_hash
  col :make_name
  col :model_name
  col :year,         :type => :integer
  col :transmission
  col :speeds
  col :drive
  col :fuel_code
  col :fuel_efficiency,               :type => :float
  col :fuel_efficiency_units
  col :fuel_efficiency_city,          :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway,       :type => :float
  col :fuel_efficiency_highway_units
  col :raw_fuel_efficiency_city,      :type => :float
  col :raw_fuel_efficiency_city_units
  col :raw_fuel_efficiency_highway,   :type => :float
  col :raw_fuel_efficiency_highway_units
  col :alt_fuel_code
  col :alt_fuel_efficiency,               :type => :float
  col :alt_fuel_efficiency_units
  col :alt_fuel_efficiency_city,          :type => :float
  col :alt_fuel_efficiency_city_units
  col :alt_fuel_efficiency_highway,       :type => :float
  col :alt_fuel_efficiency_highway_units
  col :alt_raw_fuel_efficiency_city,      :type => :float
  col :alt_raw_fuel_efficiency_city_units
  col :alt_raw_fuel_efficiency_highway,   :type => :float
  col :alt_raw_fuel_efficiency_highway_units
  col :cylinders,    :type => :integer
  col :displacement, :type => :float
  col :turbo,        :type => :boolean
  col :supercharger, :type => :boolean
  col :injection,    :type => :boolean
  col :carline_class
  add_index :make_name
  add_index :model_name
  add_index :year
end
