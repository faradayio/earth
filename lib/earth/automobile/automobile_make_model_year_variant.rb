class AutomobileMakeModelYearVariant < ActiveRecord::Base
  set_primary_key :row_hash
  
  col :row_hash
  col :make_name
  col :model_name # short name!
  col :year, :type => :integer
  col :speeds
  col :transmission
  col :drive
  col :cylinders, :type => :integer
  col :displacement, :type => :float
  col :fuel_code
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  col :raw_fuel_efficiency_city, :type => :float
  col :raw_fuel_efficiency_city_units
  col :raw_fuel_efficiency_highway, :type => :float
  col :raw_fuel_efficiency_highway_units
  col :carline_mfr_code, :type => :integer
  col :vi_mfr_code, :type => :integer
  col :carline_code, :type => :integer
  col :carline_class_code, :type => :integer
  col :injection, :type => :boolean
  col :carline_class_name
  col :speeds
  add_index :make_name
  add_index :model_name
  add_index :year
  
  # verify "Fuel code should appear in AutomobileFuel" do
  #   if (violators = connection.select_values("SELECT DISTINCT fuel_code FROM #{quoted_table_name} WHERE fuel_code NOT IN (SELECT code FROM #{AutomobileFuel.quoted_table_name})")).any?
  #     raise "Invalid fuel code(s): #{violators.join(', ')}"
  #   end
  #   true
  # end
  # 
  # verify "Fuel efficiencies should be greater than zero" do
  #   [:fuel_efficiency, :fuel_efficiency_city, :fuel_efficiency_highway].each do |field|
  #     if AutomobileMakeModelYearVariant.where(field => nil).any?
  #       raise "Invalid #{field} in automobile_make_model_year_variants: nil is not > 0"
  #     else
  #       min = AutomobileMakeModelYearVariant.minimum(field)
  #       unless min > 0
  #         raise "Invalid #{field} in automobile_make_model_year_variants: #{min} is not > 0"
  #       end
  #     end
  #   end
  # end
end