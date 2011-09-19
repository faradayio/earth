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
end