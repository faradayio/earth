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
end