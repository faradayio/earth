class AutomobileMakeModelYearVariant < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :make,            :class_name => 'AutomobileMake',          :foreign_key => 'make_name'
  belongs_to :make_model,      :class_name => 'AutomobileMakeModel',     :foreign_key => 'make_model_name'
  belongs_to :make_model_year, :class_name => 'AutomobileMakeModelYear', :foreign_key => 'make_model_year_name'
  belongs_to :fuel,            :class_name => 'AutomobileFuel',          :foreign_key => 'fuel_code', :primary_key => 'code'
  
  force_schema do
    string   'row_hash'
    string   'name' # short name!
    string   'make_name'
    string   'make_model_name' # make + model
    string   'make_year_name' # make + year
    string   'make_model_year_name' # make + model + year
    integer  'year'
    float    'fuel_efficiency'
    string   'fuel_efficiency_units'
    float    'fuel_efficiency_city'
    string   'fuel_efficiency_city_units'
    float    'fuel_efficiency_highway'
    string   'fuel_efficiency_highway_units'
    string   'fuel_code'
    string   'transmission'
    string   'drive'
    boolean  'turbo'
    boolean  'supercharger'
    integer  'cylinders'
    float    'displacement'
    float    'raw_fuel_efficiency_city'
    string   'raw_fuel_efficiency_city_units'
    float    'raw_fuel_efficiency_highway'
    string   'raw_fuel_efficiency_highway_units'
    integer  'carline_mfr_code'
    integer  'vi_mfr_code'
    integer  'carline_code'
    integer  'carline_class_code'
    boolean  'injection'
    string   'carline_class_name'
    string   'speeds'
    index    'make_name'
    index    'make_model_name'
    index    'make_year_name'
    index    'make_model_year_name'
  end
end
