class AutomobileMakeModelYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make_year,              :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_year_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_year_name'
  
  col :name # make + model + year
  col :make_name
  col :model_name
  col :make_model_name
  col :year, :type => :integer
  col :make_year_name
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units

  # TODO convert to table_warnings
  # verify "Year should be from 1985 to 2011" do
  #   AutomobileMakeModelYear.all.each do |model_year|
  #     unless model_year.year.to_i > 1984 and model_year.year.to_i < 2012
  #       raise "Invalid year for AutomobileMakeModelYear #{model_year.name}: #{model_year.year} (should be from 1985 to 2011)"
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiencies should be greater than zero" do
  #   AutomobileMakeModelYear.all.each do |model_year|
  #     %w{ city highway }.each do |type|
  #       fuel_efficiency = model_year.send(:"fuel_efficiency_#{type}")
  #       unless fuel_efficiency.to_f > 0
  #         raise "Invalid fuel efficiency #{type} for AutomobileMakeModelYear #{model_year.name}: #{fuel_efficiency} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency units should be kilometres per litre" do
  #   AutomobileMakeModelYear.all.each do |model_year|
  #     %w{ city highway }.each do |type|
  #       units = model_year.send(:"fuel_efficiency_#{type}_units")
  #       unless units == "kilometres_per_litre"
  #         raise "Invalid fuel efficiency #{type} units for AutomobileMakeModelYear #{model_year.name}: #{units} (should be kilometres_per_litre)"
  #       end
  #     end
  #   end
  # end
end
