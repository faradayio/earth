class AutomobileMakeFleetYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',     :foreign_key => 'make_name'
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'

  col :name
  col :make_year_name
  col :make_name
  col :fleet
  col :year, :type => :integer
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :volume, :type => :integer

  # TODO convert to table_warnings
  # verify "Year should be from 1978 to 2011" do
  #   connection.select_values("SELECT DISTINCT year FROM automobile_make_fleet_years").each do |year|
  #     year = year.to_i
  #     unless year > 1977 and year < 2012
  #       raise "Invalid year in automobile_make_fleet_years: #{year} is not from 1978 to 2011"
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency and volume should be greater than zero" do
  #   [:fuel_efficiency, :volume].each do |field|
  #     if AutomobileMakeFleetYear.where(field => nil).any?
  #       raise "Invalid #{field} in automobile_make_fleet_years: nil is not > 0"
  #     else
  #       min = AutomobileMakeFleetYear.minimum(field)
  #       unless min > 0
  #         raise "Invalid #{field} in automobile_make_fleet_years: #{min} is not > 0"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency units should be kilometres per litre" do
  #   connection.select_values("SELECT DISTINCT fuel_efficiency_units FROM automobile_make_fleet_years").each do |units|
  #     unless units == "kilometres_per_litre"
  #       raise "Invalid fuel efficiency units in automobile_make_fleet_years: #{units} is not 'kilometres_per_litre'"
  #     end
  #   end
  # end
end
