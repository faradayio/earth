class AutomobileMakeModelYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make_year,              :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_year_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_model_year_name'
  
  create_table do
    string   'name' # make + model + year
    string   'make_name'
    string   'model_name'
    string   'make_model_name'
    integer  'year'
    string   'make_year_name'
    float    'fuel_efficiency_city'
    string   'fuel_efficiency_city_units'
    float    'fuel_efficiency_highway'
    string   'fuel_efficiency_highway_units'
  end
end
