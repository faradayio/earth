class AutomobileMakeModel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,                   :class_name => 'AutomobileMake',                 :foreign_key => 'make_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_name'

  create_table do
    string  'name' # make + model
    string  'make_name'
    string  'model_name' # model only
    float   'fuel_efficiency_city'
    string  'fuel_efficiency_city_units'
    float   'fuel_efficiency_highway'
    string  'fuel_efficiency_highway_units'
  end
end
