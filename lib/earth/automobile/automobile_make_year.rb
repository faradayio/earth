class AutomobileMakeYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',          :foreign_key => 'make_name'
  has_many :fleet_years, :class_name => 'AutomobileMakeFleetYear', :foreign_key => 'make_year_name'

  force_schema do
    string   'name'
    string   'make_name'
    integer  'year'
    float    'fuel_efficiency'
    string   'fuel_efficiency_units'
    integer  'volume' # This will sometimes be null because not all make_years have CAFE data
  end
end
