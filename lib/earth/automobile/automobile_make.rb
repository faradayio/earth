class AutomobileMake < ActiveRecord::Base
  set_primary_key :name
  
  has_many :make_years,               :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_name'
  has_many :models,                   :class_name => 'AutomobileMakeModel',            :foreign_key => 'make_name'
  has_many :fleet_years,              :class_name => 'AutomobileMakeFleetYear',        :foreign_key => 'make_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_name'

  col :name
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units

  # TODO convert to table_warnings
  # verify "Fuel efficiency should be greater than zero" do
  #   AutomobileMake.all.each do |make|
  #     unless make.fuel_efficiency > 0
  #       raise "Invalid fuel efficiency for AutomobileMake #{make.name}: #{make.fuel_efficiency} (should be > 0)"
  #     end
  #   end
  # end
  
end
