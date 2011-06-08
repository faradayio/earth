class AutomobileMakeFleetYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',     :foreign_key => 'make_name'
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'

  create_table do
    string   'name'
    string   'make_year_name'
    string   'make_name'
    string   'fleet'
    integer  'year'
    float    'fuel_efficiency'
    string   'fuel_efficiency_units'
    integer  'volume'
  end
end
