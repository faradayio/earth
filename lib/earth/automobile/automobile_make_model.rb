class AutomobileMakeModel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,                   :class_name => 'AutomobileMake',                 :foreign_key => 'make_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_name'

  col :name # make + model
  col :make_name
  col :model_name # model only
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units

  # TODO convert to table_warnings
  # verify "Fuel efficiencies should be greater than zero" do
  #   AutomobileMakeModel.all.each do |model|
  #     %w{ city highway }.each do |type|
  #       fuel_efficiency = model.send(:"fuel_efficiency_#{type}")
  #       unless fuel_efficiency > 0
  #         raise "Invalid fuel efficiency #{type} for AutomobileMakeModel #{model.name}: #{fuel_efficiency} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Fuel efficiency units should be kilometres per litre" do
  #   AutomobileMakeModel.all.each do |model|
  #     %w{ city highway }.each do |type|
  #       units = model.send(:"fuel_efficiency_#{type}_units")
  #       unless units == "kilometres_per_litre"
  #         raise "Invalid fuel efficiency #{type} units for AutomobileMakeModel #{model.name}: #{units} (should be kilometres_per_litre)"
  #       end
  #     end
  #   end
  # end
end
